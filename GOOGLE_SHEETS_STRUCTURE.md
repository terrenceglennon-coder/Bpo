# Google Sheets Structure for 5 Whys RCA Workflow

## 📊 Overview

You need **ONE Google Sheet file** with **3 tabs (sheets)** inside it.

---

## 🗂️ Complete Structure

### Google Sheet File Name:
**"5 Whys RCA Tracker"** (or any name you prefer)

### Sheet ID:
You'll get this from the URL: `https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID_HERE/edit`

---

## 📋 Tab 1: RCA Session Tracker

**Tab Name:** `RCA Session Tracker`

**Purpose:** Track each RCA session (high-level overview)

**Columns (in order):**

| Column Letter | Column Name | Data Type | Description | Example Value |
|---------------|-------------|-----------|-------------|---------------|
| A | sessionId | Text | Unique session ID | 5WHY-1700000000000 |
| B | rcaTicket | Text | Your ticket/case ID | RCA-NOV-2024-001 |
| C | owner | Text | Username who started | john_smith |
| D | userId | Number | Telegram user ID | 123456789 |
| E | status | Text | Session status | INITIALIZED, In Progress, COMPLETED |
| F | started | DateTime | When session started | 2024-11-19 10:30:00 |
| G | completed | DateTime | When session finished | 2024-11-19 11:45:00 |
| H | currentWhy | Number | Current WHY level (0-5) | 3 |
| I | lastActivity | DateTime | Last action timestamp | 2024-11-19 11:30:00 |
| J | problemStatement | Text | The problem being analyzed | AHT increased from 420s to 485s (+15%) |
| K | overallQuality | Text | Overall data quality | Excellent, Good, Acceptable, Poor |

**Header Row (Row 1):**
```
sessionId | rcaTicket | owner | userId | status | started | completed | currentWhy | lastActivity | problemStatement | overallQuality
```

**Sample Data (Row 2):**
```
5WHY-1700000000000 | RCA-NOV-001 | john_smith | 123456789 | In Progress | 2024-11-19 10:30:00 | | 2 | 2024-11-19 11:00:00 | AHT increased from 420s to 485s (+15%) | Good
```

---

## 📋 Tab 2: 5 Whys Data Collection

**Tab Name:** `5 Whys Data Collection`

**Purpose:** Store detailed data for each of the 5 WHY levels

**Columns (in order):**

| Column Letter | Column Name | Data Type | Description | Example Value |
|---------------|-------------|-----------|-------------|---------------|
| A | sessionId | Text | Links to session | 5WHY-1700000000000 |
| B | whyLevel | Number | Which WHY (1-5) | 1 |
| C | question | Text | AI-generated question | Why did AHT increase for Team Alpha? |
| D | initialAnswer | Text | User's hypothesis | Probably due to system slowdown |
| E | dataGathered | Text | Evidence collected | System logs show 200ms latency increase. API response time went from 150ms to 350ms. Affects all agents. |
| F | validatedAnswer | Text | Data-backed conclusion | System latency increased by 133% causing longer call handling times |
| G | status | Text | Progress status | Not Started, Awaiting Data, Data Validated |
| H | dataQuality | Text | Quality score | Excellent, Good, Acceptable, Poor, Unknown |
| I | attemptCount | Number | Retry attempts | 0, 1, 2, 3 |
| J | createdAt | DateTime | When row created | 2024-11-19 10:35:00 |
| K | lastModified | DateTime | Last update | 2024-11-19 10:50:00 |

**Header Row (Row 1):**
```
sessionId | whyLevel | question | initialAnswer | dataGathered | validatedAnswer | status | dataQuality | attemptCount | createdAt | lastModified
```

**Sample Data (Rows 2-6 for one session):**

**Row 2 (Why #1):**
```
5WHY-1700000000000 | 1 | Why did AHT increase from 420s to 485s for Team Alpha? | System slowdown | System logs show API latency increased from 150ms to 350ms affecting all agents | API latency increased by 133% | Data Validated | Excellent | 0 | 2024-11-19 10:35:00 | 2024-11-19 10:50:00
```

**Row 3 (Why #2):**
```
5WHY-1700000000000 | 2 | Why did API latency increase? | Database issues | Database query time increased from 50ms to 200ms due to missing index | Missing database index causing slow queries | Data Validated | Good | 0 | 2024-11-19 11:00:00 | 2024-11-19 11:15:00
```

**Row 4 (Why #3):**
```
5WHY-1700000000000 | 3 | Why was the database index missing? | Recent deployment | Index was dropped during schema migration on Nov 11 | Schema migration script had error | Data Validated | Good | 1 | 2024-11-19 11:20:00 | 2024-11-19 11:35:00
```

**Row 5 (Why #4):**
```
5WHY-1700000000000 | 4 | Why did the migration script have an error? | Not tested properly | No pre-production testing was done for this migration | Migration deployed without testing | Data Validated | Acceptable | 0 | 2024-11-19 11:40:00 | 2024-11-19 11:55:00
```

**Row 6 (Why #5):**
```
5WHY-1700000000000 | 5 | Why was no pre-production testing done? | Process not followed | Team skipped staging deployment due to time pressure | Staging environment deployment step was skipped | Data Validated | Good | 0 | 2024-11-19 12:00:00 | 2024-11-19 12:15:00
```

---

## 📋 Tab 3: RCA Final Reports

**Tab Name:** `RCA Final Reports`

**Purpose:** Store final analysis and action plans

**Columns (in order):**

| Column Letter | Column Name | Data Type | Description | Example Value |
|---------------|-------------|-----------|-------------|---------------|
| A | sessionId | Text | Links to session | 5WHY-1700000000000 |
| B | rcaTicket | Text | Ticket/case ID | RCA-NOV-001 |
| C | problemStatement | Text | Original problem | AHT increased from 420s to 485s (+15%) |
| D | finalAnalysis | Long Text | Complete RCA summary | **ROOT CAUSE:** Staging deployment step skipped... |
| E | overallQuality | Text | Overall quality | Excellent, Good, Acceptable |
| F | completedAt | DateTime | When analysis done | 2024-11-19 12:30:00 |
| G | status | Text | Report status | COMPLETED |

**Header Row (Row 1):**
```
sessionId | rcaTicket | problemStatement | finalAnalysis | overallQuality | completedAt | status
```

**Sample Data (Row 2):**
```
5WHY-1700000000000 | RCA-NOV-001 | AHT increased from 420s to 485s (+15%) | **ROOT CAUSE:** Staging deployment step was skipped due to time pressure, leading to untested schema migration that dropped critical database index... [full analysis] | Good | 2024-11-19 12:30:00 | COMPLETED
```

---

## 🎯 Quick Setup Steps

### Step 1: Create Google Sheet
1. Go to [sheets.google.com](https://sheets.google.com)
2. Click "Blank" to create new sheet
3. Name it: **"5 Whys RCA Tracker"**

### Step 2: Create Tab 1 - RCA Session Tracker
1. Rename "Sheet1" to `RCA Session Tracker`
2. In Row 1, add these headers:
   ```
   sessionId | rcaTicket | owner | userId | status | started | completed | currentWhy | lastActivity | problemStatement | overallQuality
   ```

### Step 3: Create Tab 2 - 5 Whys Data Collection
1. Click "+" to add new sheet
2. Name it: `5 Whys Data Collection`
3. In Row 1, add these headers:
   ```
   sessionId | whyLevel | question | initialAnswer | dataGathered | validatedAnswer | status | dataQuality | attemptCount | createdAt | lastModified
   ```

### Step 4: Create Tab 3 - RCA Final Reports
1. Click "+" to add new sheet
2. Name it: `RCA Final Reports`
3. In Row 1, add these headers:
   ```
   sessionId | rcaTicket | problemStatement | finalAnalysis | overallQuality | completedAt | status
   ```

### Step 5: Copy Sheet ID
1. Look at URL: `https://docs.google.com/spreadsheets/d/`**`1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms`**`/edit`
2. Copy the ID (the long string between `/d/` and `/edit`)
3. Use this in your `GOOGLE_SHEET_ID` environment variable

### Step 6: Share Sheet
1. Click "Share" button
2. If using Service Account: Add service account email with "Editor" permissions
3. If using OAuth2: Make sure your Google account has access

---

## 📸 Visual Guide

### Your Sheet Should Look Like This:

```
┌─────────────────────────────────────────────────────────────┐
│  📄 5 Whys RCA Tracker                                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Tabs at bottom:                                            │
│  ┌──────────────────┐ ┌──────────────────┐ ┌─────────────┐│
│  │ RCA Session      │ │ 5 Whys Data      │ │ RCA Final   ││
│  │ Tracker          │ │ Collection       │ │ Reports     ││
│  └──────────────────┘ └──────────────────┘ └─────────────┘│
│                                                             │
│  Tab 1: 11 columns (sessionId through overallQuality)      │
│  Tab 2: 11 columns (sessionId through lastModified)        │
│  Tab 3: 7 columns (sessionId through status)               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ Verification Checklist

Before using the workflow, verify:

- [ ] ✅ **ONE Google Sheet file** created
- [ ] ✅ **3 tabs** inside (not 3 separate files!)
- [ ] ✅ Tab names match exactly:
  - `RCA Session Tracker`
  - `5 Whys Data Collection`
  - `RCA Final Reports`
- [ ] ✅ Column headers match exactly (including case)
- [ ] ✅ Column order matches (A, B, C, etc.)
- [ ] ✅ Sheet ID copied from URL
- [ ] ✅ Sheet shared with service account or OAuth user
- [ ] ✅ Empty rows below headers (workflow will add data)

---

## 🔍 Common Mistakes

❌ **WRONG:** Creating 3 separate Google Sheet files
✅ **RIGHT:** One file with 3 tabs inside

❌ **WRONG:** Tab names: "Sheet1", "Sheet2", "Sheet3"
✅ **RIGHT:** Tab names: "RCA Session Tracker", "5 Whys Data Collection", "RCA Final Reports"

❌ **WRONG:** Columns in wrong order
✅ **RIGHT:** Columns match exactly as specified above

❌ **WRONG:** Using underscores: "session_id", "rca_ticket"
✅ **RIGHT:** Using camelCase: "sessionId", "rcaTicket"

---

## 📝 Example Values Reference

### Session Statuses:
- `INITIALIZED` - Just created
- `Problem Defined` - Problem statement collected
- `In Progress` - Working through Whys
- `COMPLETED` - All done

### WHY Statuses:
- `Not Started` - Row created, waiting
- `Awaiting Data` - Question sent, waiting for user
- `Data Validated` - User filled data, validated

### Data Quality Levels:
- `Excellent` - All fields + metrics + detailed (50+ chars)
- `Good` - All fields + some metrics
- `Acceptable` - All fields filled, meets minimums
- `Poor` - Missing fields or too short
- `Unknown` - Not yet validated

---

## 💡 Pro Tips

1. **Freeze Header Row:**
   - Select Row 1
   - View → Freeze → 1 row
   - Makes scrolling easier

2. **Format DateTime Columns:**
   - Select datetime columns (F, G, I, J, K)
   - Format → Number → Date time
   - Easier to read

3. **Auto-Resize Columns:**
   - Select all columns
   - Double-click column border
   - Fits content perfectly

4. **Color Code Headers:**
   - Select Row 1
   - Background color: Light blue
   - Bold text
   - Easier to identify

---

## 🚀 Ready to Use!

Once your sheet is set up:

1. ✅ Copy the Sheet ID
2. ✅ Set `GOOGLE_SHEET_ID` environment variable in n8n
3. ✅ Configure Google Sheets credentials
4. ✅ Import workflows
5. ✅ Test with `/start5whys TEST-001`

The workflow will automatically:
- Create session row in Tab 1
- Create 5 rows in Tab 2 (one for each WHY)
- Fill data as you progress
- Add final report to Tab 3

---

## 📞 Need Help?

If you're still confused:
1. Share a screenshot of your Google Sheet
2. Show the tab names at bottom
3. Show the column headers in Row 1

I can help you fix it!

---

**File Created:** 2024-11-19
**Purpose:** Google Sheets structure guide for 5 Whys RCA workflow
**Applies to:** Both Traditional and AI Agent approaches
