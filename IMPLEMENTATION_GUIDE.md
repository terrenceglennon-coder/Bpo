# Invoice Uploader - Telegram Implementation Guide

## Quick Start

This guide will help you adapt the Slack-based invoice workflow to Telegram with critical improvements.

---

## Prerequisites

### 1. Create Telegram Bot
1. Open Telegram and search for `@BotFather`
2. Send `/newbot` command
3. Follow prompts to name your bot
4. Save the **Bot Token** (looks like: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

### 2. Get Your Chat ID
1. Send a message to your new bot
2. Visit: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
3. Find `"chat":{"id":123456789}` in the response
4. Save this **Chat ID**

### 3. Configure n8n Credentials
1. In n8n, go to **Settings** → **Credentials**
2. Click **Add Credential**
3. Select **Telegram API**
4. Enter your Bot Token
5. Save the credential

---

## Implementation Steps

### Step 1: Import the Telegram Workflow

1. Copy the contents of `invoice-uploader-telegram.json`
2. In n8n, click **Add Workflow** → **Import from File**
3. Paste the JSON content
4. Click **Import**

### Step 2: Update Credential References

Replace these placeholder IDs in the workflow:

```json
"YOUR_TELEGRAM_CREDENTIALS_ID" → Your actual Telegram credential ID
"YOUR_GOOGLE_SHEETS_CREDENTIALS_ID" → Your Google Sheets credential ID
"YOUR_GOOGLE_DRIVE_CREDENTIALS_ID" → Your Google Drive credential ID
"YOUR_OPENAI_CREDENTIALS_ID" → Your OpenAI credential ID
```

**How to find credential IDs:**
- Open any node using a credential
- Click the credential dropdown
- The ID is shown next to each credential name

### Step 3: Add File Download Functionality

**IMPORTANT**: Telegram doesn't automatically download files. You need to add a download step.

**Option A: Using Telegram Node (Recommended)**

Add these nodes between "Telegram Trigger" and "Detect File Type":

1. **Code Node** - "Extract File Info"
   - Copy code from `telegram-file-handler.js`
   - This extracts file_id from the Telegram message

2. **Telegram Node** - "Download File"
   - Operation: `getFile`
   - File ID: `={{ $json.telegram_file_id }}`
   - Download: `Yes`
   - Binary Property: `file_0`

**Option B: Using HTTP Request Node**

If the Telegram node doesn't work:

```javascript
// HTTP Request Node settings
Method: GET
URL: https://api.telegram.org/bot{{ $credentials.telegramApi.accessToken }}/getFile?file_id={{ $json.telegram_file_id }}

// Then another HTTP Request to download:
URL: https://api.telegram.org/file/bot{{ $credentials.telegramApi.accessToken }}/{{ $json.result.file_path }}
Response Format: File
Binary Property: file_0
```

### Step 4: Add Data Validation Node

Insert a **Code Node** after "Parse Invoice Data":

1. Add new Code node named "Validate Invoice Data"
2. Copy code from `invoice-data-validator.js`
3. Connect:
   - Input: From "Parse Invoice Data"
   - Output: To "Merge Data"

### Step 5: Fix Markdown Formatting

The "Parse Invoice Data" node needs Telegram-compatible markdown:

**Change this** (in the jsCode parameter):
```javascript
markdown = `
**Invoice Summary**
- **Invoice #:** ${...}
```

**To this**:
```javascript
markdown = `
*Invoice Summary*

*Invoice #:* ${...}
*Vendor:* ${...}
```

This is already done in the provided `invoice-uploader-telegram.json`.

### Step 6: Update Google Sheets Column

Fix the typo in your Google Sheet:
1. Open your spreadsheet
2. Rename column "Discription" to "Description"
3. Update the workflow mapping:
   ```json
   "Description": "={{ $json.data[0].description }}"
   ```

### Step 7: Secure Google Drive Sharing

In the "Share Drive File" node, change sharing settings:

**Current (insecure)**:
```json
"type": "anyone"
```

**Better (domain-restricted)**:
```json
"type": "domain",
"domain": "yourcompany.com"
```

**Or use specific people**:
```json
"type": "user",
"emailAddress": "accounting@yourcompany.com"
```

### Step 8: Set Up Error Handling

1. Import `error-handler-workflow.json` as a separate workflow
2. Get the Error Handler workflow ID:
   - Open the error handler workflow
   - Check the URL: `.../workflow/<WORKFLOW_ID>`
3. In your main workflow settings:
   - Click **Workflow Settings** (gear icon)
   - Set **Error Workflow**: Select your error handler
4. In error handler, replace:
   - `ADMIN_CHAT_ID` → Your Telegram chat ID (for admin alerts)
   - `YOUR_ERROR_LOG_SHEET_ID` → ID of Google Sheet for error logging
   - All credential placeholders

### Step 9: Add Processing Acknowledgment

Add a **Telegram Node** right after "Telegram Trigger":

```json
{
  "name": "Acknowledge Receipt",
  "chatId": "={{ $json.message.chat.id }}",
  "text": "⏳ Processing your invoice... This may take 10-30 seconds.",
  "additionalFields": {
    "reply_to_message_id": "={{ $json.message.message_id }}"
  }
}
```

This gives immediate feedback to users.

### Step 10: Test the Workflow

1. **Activate** the workflow in n8n
2. **Send a test invoice** to your Telegram bot:
   - Send a photo of an invoice
   - Or send a PDF document
3. **Monitor execution**:
   - Check n8n execution log
   - Verify Google Sheets entry
   - Check Google Drive upload
   - Confirm Telegram response

---

## Testing Checklist

- [ ] Telegram bot responds to messages
- [ ] Image invoices are processed correctly
- [ ] PDF invoices are processed correctly
- [ ] Extracted data appears in Google Sheets
- [ ] Files are uploaded to Google Drive
- [ ] Drive file links work in Sheets
- [ ] Telegram confirmation message is sent
- [ ] Error handler catches and reports errors
- [ ] Invalid files show user-friendly error messages
- [ ] Data validation rejects bad data
- [ ] Processing acknowledgment appears quickly

---

## Common Issues & Solutions

### Issue 1: "File not found" or "Binary data missing"

**Cause**: Telegram file not downloaded properly

**Solution**:
- Ensure the file download node is placed correctly
- Check the binary property name is `file_0`
- Verify Telegram credentials are valid

### Issue 2: "OpenAI extraction returns nothing"

**Cause**: Binary data not passed correctly

**Solution**:
- In "Detect File Type" node, check binary normalization
- Ensure `binaryPropertyName` in OpenAI nodes is `file_0`
- Test with a clear, high-quality invoice image

### Issue 3: "Google Sheets 'File Link' column is empty"

**Cause**: Google Drive node output not merged correctly

**Solution**:
- Check the Merge node connections
- Verify "Google Drive" node comes before "Share Drive File"
- Ensure both outputs merge before Aggregate

### Issue 4: "Validation errors on all invoices"

**Cause**: Validation rules too strict

**Solution**:
- Review `invoice-data-validator.js`
- Adjust `config.requiredFields` if needed
- Change errors to warnings for less critical checks

### Issue 5: "Telegram message formatting looks wrong"

**Cause**: Using Slack markdown instead of Telegram markdown

**Solution**:
- Telegram uses single `*` for bold, not `**`
- Ensure `parse_mode: "Markdown"` is set
- Use `\n` for line breaks, not blank lines

---

## Performance Optimization Tips

### 1. Reduce OpenAI Costs

Test if GPT-4o-mini works for both images AND PDFs:
```json
{
  "modelId": "gpt-4o-mini"  // Instead of gpt-4o for images
}
```

**Potential savings**: 60-80% on AI costs

### 2. Parallel Processing

Rearrange workflow so Google Drive upload happens in parallel with AI processing:

```
Telegram Trigger → Split into 2 paths:
                   Path 1: AI Processing → Parse → Merge
                   Path 2: Upload to Drive → Share → Merge
```

**Time saved**: 2-5 seconds per invoice

### 3. Shorten OpenAI Prompt

The current prompt is verbose. Shorter version:

```
Extract invoice data as JSON:
{invoice_number, vendor, date, due_date, description, subtotal, tax, total, email, status}

Rules:
- Dates: YYYY-MM-DD
- Numbers only, no currency symbols
- status: Paid|Unpaid|Overdue|null
- null if field not found
```

**Savings**: ~30% fewer tokens = lower cost

---

## Security Checklist

- [ ] Telegram bot token is stored securely (use n8n credentials, not hardcoded)
- [ ] Google Drive files are NOT shared publicly
- [ ] Only authorized users can send invoices to bot
- [ ] Error messages don't expose sensitive data
- [ ] API keys are not logged or exposed
- [ ] Webhook URL is HTTPS (n8n cloud handles this automatically)

---

## Optional Enhancements

### Add Duplicate Detection

Before "Update Google Sheet" node, add:

**Google Sheets Node** - "Check for Duplicate"
- Operation: `Lookup`
- Lookup Column: `Invoice#`
- Lookup Value: `={{ $json.data[0].invoice_number }}`

Then add **If Node**:
- If found → Notify user: "This invoice was already submitted"
- If not found → Continue to insert

### Add User Whitelist

After "Telegram Trigger", add Code node:

```javascript
const allowedUsers = [123456789, 987654321]; // Your user IDs
const userId = $input.first().json.message.from.id;

if (!allowedUsers.includes(userId)) {
  throw new Error('Unauthorized user');
}

return [$input.first()];
```

### Add Help Command

In Telegram Trigger settings:
- Enable "message" update type
- Add filter for commands

Then add Switch node:
- Route `/start` and `/help` to a Telegram node with instructions
- Route everything else to file processing

---

## Monitoring & Maintenance

### Daily Checks
- Review error log sheet for patterns
- Check Google Drive quota usage
- Monitor OpenAI API costs

### Weekly Reviews
- Analyze extraction accuracy
- Review validation warnings
- Check for duplicate invoices
- Verify all links in sheets are working

### Monthly Tasks
- Archive old invoices to separate sheet
- Review and optimize OpenAI prompts
- Update validation rules based on new vendors
- Check for n8n workflow updates

---

## Support & Troubleshooting

### n8n Community Forum
https://community.n8n.io/

### Telegram Bot API Docs
https://core.telegram.org/bots/api

### OpenAI API Docs
https://platform.openai.com/docs/

### Common Error Codes

| Error | Meaning | Solution |
|-------|---------|----------|
| 403 Forbidden | Telegram bot blocked | User needs to unblock bot |
| 400 Bad Request | Invalid message format | Check markdown syntax |
| 429 Too Many Requests | Rate limit hit | Add delay between requests |
| 500 Internal Error | n8n/API issue | Check service status, retry |

---

## Next Steps After Setup

1. ✅ Run 10-20 test invoices
2. ✅ Train users on how to submit invoices
3. ✅ Document your specific vendor formats
4. ✅ Set up monthly cost tracking
5. ✅ Consider Phase 2 enhancements from WORKFLOW_ANALYSIS.md

---

## Cost Estimation

**Per Invoice (with optimizations)**:
- OpenAI API: $0.005 - $0.015
- Google Drive: Free (under 15GB)
- Google Sheets: Free
- Telegram: Free
- n8n: Depends on plan (Cloud: included, Self-hosted: free)

**Monthly (100 invoices)**:
- Total: ~$0.50 - $1.50

**Annual (1,200 invoices)**:
- Total: ~$6 - $18

Compare to manual data entry time saved: **Priceless** 🚀

---

## Success Metrics

Track these KPIs:
- ✅ Invoices processed per week
- ✅ Extraction accuracy rate (% requiring manual correction)
- ✅ Average processing time
- ✅ Error rate
- ✅ Cost per invoice
- ✅ Time saved vs manual entry

**Target benchmarks**:
- Accuracy: >95%
- Processing time: <30 seconds
- Error rate: <5%
- Cost per invoice: <$0.02

---

## Congratulations! 🎉

You now have a production-ready invoice processing system with:
- ✅ Telegram integration
- ✅ Robust error handling
- ✅ Data validation
- ✅ Secure file storage
- ✅ User feedback
- ✅ Admin monitoring

For advanced features, see Phase 2-4 in `WORKFLOW_ANALYSIS.md`.
