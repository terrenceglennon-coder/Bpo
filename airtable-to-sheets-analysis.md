# Airtable to Google Sheets Migration - Current Structure Analysis

## Current Airtable Setup

### Base Information
- **Base ID**: appCRmoSqgAx8xPr9 (Client Contacts)
- **Table ID**: tblVusedLZe5RGuEz (Clients)

### Field Structure
| Field Name | Type | Writable | Notes |
|------------|------|----------|-------|
| Full Name | String | ✅ | Required |
| Photo | Array | ✅ | Optional |
| Email Address | String | ✅ | Required, Used for matching |
| Phone Number | String | ✅ | Optional |
| Company Name | String | ✅ | Optional |
| Address | String | ✅ | Optional |
| Date Added | DateTime | ✅ | Auto-populated |
| Days Since Added | String | ❌ | Formula field |
| First Name | String | ❌ | Formula field |
| Last Name | String | ❌ | Formula field |
| Client Summary (AI) | String | ✅ | Optional |
| Client Type (AI) | String | ✅ | Optional |
| Account | String | ✅ | Optional |

### Current Operations
1. **Get Contacts** - Search with filterByFormula
2. **Create a New** - Create new records
3. **Add or Update** - Upsert matching on Email Address
4. **Delete** - Delete by record ID

### Integration Points
- Used by: Contact Agent1 → Ultimate Media Agent
- Connected to: Email Agent (for contact lookup)
- Connected to: Calendar Agent (for event attendees)

## Google Sheets Equivalent Structure

### Proposed Sheet Structure
**Sheet Name**: "Contacts"

| Column A | Column B | Column C | Column D | Column E | Column F | Column G | Column H | Column I | Column J | Column K | Column L |
|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|
| Row # | Full Name | Email Address | Phone Number | Company Name | Address | Date Added | First Name | Last Name | Client Summary (AI) | Client Type (AI) | Account |

### Formula Columns (Auto-calculated in Google Sheets)
- **Row #**: `=ROW()-1` (for easy reference)
- **First Name**: `=SPLIT(B2," ",TRUE,TRUE)` (extract first word)
- **Last Name**: `=ARRAYFORMULA(IF(B2:B<>"",REGEXEXTRACT(B2:B,".* (.*)$"),""))` (extract last word)
- **Days Since Added**: `=IF(G2<>"",DAYS(TODAY(),G2),"")` (calculate days)
- **Date Added**: Auto-populate with `=NOW()` on creation

### Key Differences from Airtable
| Feature | Airtable | Google Sheets | Impact |
|---------|----------|---------------|--------|
| Unique IDs | Auto-generated record ID | Row number or manual ID | Need row tracking |
| Formula Fields | Computed automatically | Use ARRAYFORMULA | Same functionality |
| Photo Storage | Native attachment | URL links only | Need Drive integration |
| Search | FilterByFormula | QUERY function | Different syntax |
| API | Direct record operations | Row-based operations | Need row finding |
| Upsert | Native support | Manual implementation | More complex |

## Migration Considerations

### Advantages of Google Sheets
✅ Already integrated (Sheet Agent exists)
✅ No external API costs
✅ Easier to view/edit manually
✅ Better for bulk operations
✅ Native Google Workspace integration
✅ Simpler permission management

### Challenges
⚠️ Need to implement upsert logic manually
⚠️ Photo storage requires Google Drive links
⚠️ No native unique IDs (use row numbers)
⚠️ Search requires QUERY syntax or Code node
⚠️ Less structured than Airtable
⚠️ Need validation for data integrity

## Recommended Sheet Setup

### Sheet 1: "Contacts"
```
A: Row #
B: Full Name
C: Email Address (unique)
D: Phone Number
E: Company Name
F: Address
G: Date Added
H: Client Summary (AI)
I: Client Type (AI)
J: Account
K: Photo URL (Google Drive link)
```

### Sheet 2: "Metadata" (optional)
```
A: Last Updated
B: Total Contacts
C: Last Contact ID
```

### Data Validation Rules
- Email Address: Must be unique, valid email format
- Full Name: Required field
- Date Added: Auto-populated, datetime format

## Next Steps
1. Create Google Sheet with proper structure
2. Migrate existing Airtable data
3. Implement 3 different integration approaches
4. Test all CRUD operations
5. Update Contact Agent configuration
