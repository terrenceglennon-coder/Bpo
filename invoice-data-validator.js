/**
 * Invoice Data Validator Node
 *
 * This Code node should be placed after "Parse Invoice Data"
 * and before the "Merge Data" node to validate extracted invoice data.
 *
 * It ensures data quality before inserting into Google Sheets.
 */

const item = $input.first();
const data = item.json;

// Validation configuration
const config = {
  requiredFields: ['vendor', 'total'],
  optionalFields: ['invoice_number', 'date', 'due_date', 'description', 'subtotal', 'tax', 'email', 'status'],
  dateFields: ['date', 'due_date'],
  numericFields: ['subtotal', 'tax', 'total'],
  statusValues: ['Paid', 'Unpaid', 'Overdue', null],
  maxAmountLimit: 1000000, // $1M sanity check
  minYear: 2020,
  maxFutureYears: 2
};

// Validation results
const errors = [];
const warnings = [];
const fixes = {};

// ============================================
// 1. REQUIRED FIELDS VALIDATION
// ============================================
config.requiredFields.forEach(field => {
  if (!data[field] || data[field] === 'N/A' || data[field] === '') {
    errors.push(`Missing required field: ${field}`);
  }
});

// ============================================
// 2. DATE VALIDATION
// ============================================
const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
const today = new Date();
const minDate = new Date(`${config.minYear}-01-01`);
const maxDate = new Date();
maxDate.setFullYear(today.getFullYear() + config.maxFutureYears);

config.dateFields.forEach(field => {
  const value = data[field];

  if (value && value !== null) {
    // Check format
    if (!dateRegex.test(value)) {
      errors.push(`Invalid date format for ${field}: ${value}. Expected YYYY-MM-DD`);
      return;
    }

    // Check if valid date
    const date = new Date(value);
    if (isNaN(date.getTime())) {
      errors.push(`Invalid date for ${field}: ${value}`);
      return;
    }

    // Check if in reasonable range
    if (date < minDate) {
      warnings.push(`${field} (${value}) is before ${config.minYear}. Please verify.`);
    }
    if (date > maxDate) {
      warnings.push(`${field} (${value}) is more than ${config.maxFutureYears} years in the future.`);
    }
  }
});

// Check due_date is after date
if (data.date && data.due_date) {
  const invoiceDate = new Date(data.date);
  const dueDate = new Date(data.due_date);

  if (dueDate < invoiceDate) {
    warnings.push(`Due date (${data.due_date}) is before invoice date (${data.date})`);
  }
}

// ============================================
// 3. NUMERIC FIELDS VALIDATION
// ============================================
config.numericFields.forEach(field => {
  const value = data[field];

  if (value !== null && value !== undefined) {
    const num = Number(value);

    // Check if valid number
    if (isNaN(num)) {
      errors.push(`Invalid number for ${field}: ${value}`);
      return;
    }

    // Check if negative
    if (num < 0) {
      errors.push(`Negative value for ${field}: ${value}`);
      return;
    }

    // Sanity check for very large amounts
    if (num > config.maxAmountLimit) {
      warnings.push(`${field} ($${num.toFixed(2)}) exceeds $${config.maxAmountLimit}. Please verify.`);
    }

    // Ensure 2 decimal places for currency
    fixes[field] = Number(num.toFixed(2));
  }
});

// ============================================
// 4. CALCULATION VALIDATION
// ============================================
if (data.subtotal !== null && data.tax !== null && data.total !== null) {
  const subtotal = Number(data.subtotal);
  const tax = Number(data.tax);
  const total = Number(data.total);
  const calculatedTotal = subtotal + tax;

  // Allow 1 cent tolerance for rounding
  if (Math.abs(calculatedTotal - total) > 0.01) {
    warnings.push(
      `Math mismatch: Subtotal ($${subtotal.toFixed(2)}) + Tax ($${tax.toFixed(2)}) = ` +
      `$${calculatedTotal.toFixed(2)}, but Total is $${total.toFixed(2)}`
    );
  }
}

// ============================================
// 5. STATUS VALIDATION
// ============================================
if (data.status && !config.statusValues.includes(data.status)) {
  warnings.push(`Unexpected status value: "${data.status}". Expected: ${config.statusValues.filter(v => v).join(', ')}`);
}

// Auto-detect overdue status
if (data.status === 'Unpaid' && data.due_date) {
  const dueDate = new Date(data.due_date);
  if (dueDate < today) {
    fixes.status = 'Overdue';
    warnings.push(`Status changed from "Unpaid" to "Overdue" (due date: ${data.due_date})`);
  }
}

// ============================================
// 6. EMAIL VALIDATION
// ============================================
if (data.email && data.email !== null && data.email !== 'N/A') {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(data.email)) {
    warnings.push(`Invalid email format: ${data.email}`);
  }
}

// ============================================
// 7. INVOICE NUMBER VALIDATION
// ============================================
if (data.invoice_number) {
  // Check for common OCR errors
  if (data.invoice_number.includes('O0') || data.invoice_number.includes('0O')) {
    warnings.push(`Invoice number "${data.invoice_number}" may contain OCR confusion (O vs 0)`);
  }
}

// ============================================
// APPLY FIXES
// ============================================
const validatedData = {
  ...data,
  ...fixes
};

// ============================================
// VALIDATION SUMMARY
// ============================================
const validationSummary = {
  passed: errors.length === 0,
  errors: errors,
  warnings: warnings,
  fixes_applied: Object.keys(fixes),
  timestamp: new Date().toISOString()
};

// ============================================
// HANDLE VALIDATION RESULT
// ============================================
if (errors.length > 0) {
  // Critical errors - halt execution
  throw new Error(
    `❌ Invoice validation failed:\n\n` +
    errors.map(e => `• ${e}`).join('\n') +
    `\n\nPlease check the invoice and try again.`
  );
}

// If only warnings, log them but continue
if (warnings.length > 0) {
  console.log('⚠️ Validation warnings:', warnings);
}

// ============================================
// OUTPUT
// ============================================
return [{
  json: {
    ...validatedData,
    _validation: validationSummary
  },
  binary: item.binary
}];
