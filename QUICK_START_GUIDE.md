# 5 Whys RCA Workflow - Quick Start Guide

## 🚀 Get Started in 15 Minutes

This guide will help you set up and deploy the improved 5 Whys RCA workflow.

---

## ✅ Prerequisites

Before you begin, ensure you have:

- [ ] n8n instance running (cloud or self-hosted)
- [ ] Google account with Sheets access
- [ ] Telegram account
- [ ] Anthropic Claude API account (or API key)

---

## 📋 Step-by-Step Setup

### Step 1: Create Google Sheet (5 minutes)

1. **Create a new Google Sheet**
   - Go to [sheets.google.com](https://sheets.google.com)
   - Click "Blank" to create new sheet
   - Name it: "5 Whys RCA Tracker"

2. **Create Tab 1: RCA Session Tracker**
   - Rename "Sheet1" to "RCA Session Tracker"
   - Add these headers in row 1:
     ```
     sessionId | rcaTicket | owner | userId | status | started | completed | currentWhy | lastActivity | problemStatement | overallQuality
     ```

3. **Create Tab 2: 5 Whys Data Collection**
   - Click "+" to add new sheet
   - Name it "5 Whys Data Collection"
   - Add these headers:
     ```
     sessionId | whyLevel | question | initialAnswer | dataGathered | validatedAnswer | status | dataQuality | attemptCount | createdAt | lastModified
     ```

4. **Create Tab 3: RCA Final Reports**
   - Click "+" to add new sheet
   - Name it "RCA Final Reports"
   - Add these headers:
     ```
     sessionId | rcaTicket | problemStatement | finalAnalysis | overallQuality | completedAt | status
     ```

5. **Copy the Sheet ID**
   - Look at the URL: `https://docs.google.com/spreadsheets/d/`**`1BxiMVs...upms`**`/edit`
   - Copy the ID between `/d/` and `/edit`
   - Save this for later

6. **Share the Sheet (if using Service Account)**
   - Click "Share" button
   - Add your service account email
   - Give "Editor" permissions

### Step 2: Create Telegram Bot (3 minutes)

1. **Open Telegram** and search for `@BotFather`

2. **Create new bot**
   ```
   You: /newbot
   BotFather: Alright, a new bot. How are we going to call it?
   You: 5 Whys RCA Bot
   BotFather: Good. Now let's choose a username for your bot.
   You: my_company_5whys_bot
   ```

3. **Copy the API Token**
   - BotFather will give you a token like: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`
   - Save this for later

4. **Configure bot settings** (optional)
   ```
   /setdescription - Set bot description
   /setcommands - Set command list
   ```

5. **Set bot commands** (recommended)
   ```
   start5whys - Start new RCA session
   status - Check session progress
   help - Show help information
   cancel - Cancel current session
   ```

### Step 3: Get Claude API Key (2 minutes)

1. **Sign up/Login** to [Anthropic Console](https://console.anthropic.com/)

2. **Create API Key**
   - Go to "API Keys" section
   - Click "Create Key"
   - Name it: "5 Whys RCA Workflow"
   - Copy the key: `sk-ant-api03-xxxxx`
   - Save this for later

3. **Check your credits** (optional)
   - Ensure you have sufficient API credits
   - Sonnet 4 costs ~$3 per 1M input tokens

### Step 4: Configure n8n Environment (3 minutes)

1. **Open n8n** instance

2. **Go to Settings** → **Environment Variables**

3. **Add these variables:**
   ```
   GOOGLE_SHEET_ID = [paste your Sheet ID]
   ANTHROPIC_API_KEY = [paste your Claude API key]
   TELEGRAM_BOT_TOKEN = [paste your Bot token]
   CLAUDE_MODEL = claude-sonnet-4-20250514
   USER_RESPONSE_TIMEOUT = 3600000
   MAX_API_RETRIES = 3
   ```

4. **Save** environment variables

### Step 5: Set Up n8n Credentials (2 minutes)

1. **Telegram API Credential**
   - Go to **Credentials** → **New**
   - Select "Telegram API"
   - Name: "Telegram Bot - 5 Whys"
   - Access Token: Use `{{ $env.TELEGRAM_BOT_TOKEN }}`
   - Save

2. **Google Sheets OAuth2 Credential**
   - Go to **Credentials** → **New**
   - Select "Google Sheets OAuth2 API"
   - Name: "Google Sheets - RCA"
   - Follow OAuth2 flow or use Service Account
   - Save

3. **Note the Credential IDs**
   - You'll need these when importing the workflow

### Step 6: Import Workflow (2 minutes)

1. **Download workflow file**
   - `5-whys-rca-improved.json`

2. **Import in n8n**
   - Click **"Import from File"**
   - Select the JSON file
   - Click **"Import"**

3. **Update credential references**
   - Open each node that uses credentials
   - Select your credentials from dropdown
   - Save

4. **Activate the workflow**
   - Toggle the switch at top to "Active"

---

## 🧪 Test the Workflow

### Test 1: Help Command
```
You → Bot: /help
Bot → You: [Help message with all commands]
```
✅ **Expected:** Bot sends comprehensive help message

### Test 2: Start Session
```
You → Bot: /start5whys TEST-001
Bot → You: [Welcome message with session details]
```
✅ **Expected:** Bot creates session and asks for problem statement

### Test 3: Problem Statement
```
You → Bot: AHT increased from 420s to 485s (+15%) starting Nov 12
Bot → You: [Problem accepted, WHY #1 question]
```
✅ **Expected:** Bot validates and sends first Why question

### Test 4: Data Collection
```
1. Open Google Sheet
2. Find row "Why #1"
3. Fill in the 3 columns
4. Reply: /ready1
```
✅ **Expected:** Bot validates data and proceeds to Why #2

### Test 5: Complete Flow
- Complete all 5 Whys
- Check final analysis
- Verify Google Sheet has all data
- Check Final Reports tab

---

## 🎯 Usage Guide for End Users

### Starting a New RCA

1. **Initiate session**
   ```
   /start5whys RCA-NOV-2024-001
   ```
   Replace with your ticket ID

2. **Provide problem statement**
   ```
   AHT increased from 420s to 485s (+15%)
   starting Nov 12, 2024
   Affecting all agents in Team Alpha
   ```
   Include:
   - Specific metric
   - Baseline vs current
   - Date/timeframe
   - Scope (who/what affected)

3. **For each Why (1-5):**

   a. **Read the AI question**
      - Bot sends specific question
      - Data gathering guidance
      - Specific checks to perform

   b. **Gather data**
      - Pull reports
      - Check dashboards
      - Interview stakeholders
      - Collect evidence

   c. **Fill Google Sheet**
      - Open the linked sheet
      - Find your Why level row
      - Fill 3 columns:
        - **Initial Answer:** Your hypothesis
        - **Data Gathered:** Evidence you found
        - **Validated Answer:** Data-backed conclusion

   d. **Notify bot**
      ```
      /ready1   (for Why #1)
      /ready2   (for Why #2)
      ... etc
      ```

4. **Review final analysis**
   - Bot generates comprehensive RCA
   - Includes root cause
   - Action plan
   - Success metrics

### Checking Progress
```
/status
```
Shows:
- Current progress (X/5 Whys)
- Session details
- Data quality
- Next steps

### Getting Help
```
/help
```
Shows all commands and usage

### Canceling Session
```
/cancel
```
Stops current session (data preserved in Sheet)

---

## 📊 Understanding Data Quality

### Quality Ratings

**Excellent** 🌟
- All fields filled
- Contains metrics/numbers
- Detailed data (50+ characters)
- Specific evidence

**Good/Acceptable** ✅
- All required fields filled
- Meets minimum length
- Some metrics present

**Poor** ⚠️
- Missing fields
- Too short
- No metrics
- Vague answers

**Missing** ❌
- Empty fields
- No data provided

### Tips for High Quality Data

✅ **DO:**
- Include specific metrics and numbers
- Provide detailed evidence
- Reference actual data sources
- Be specific (names, dates, values)
- Show your work (how you analyzed)

❌ **DON'T:**
- Guess or assume
- Use vague language ("some users", "sometimes")
- Skip data gathering
- Provide opinions without data
- Rush through the process

---

## 🔍 Troubleshooting

### Problem: Bot doesn't respond

**Possible causes:**
- Workflow not activated
- Telegram credentials incorrect
- n8n instance down

**Solutions:**
1. Check workflow is "Active" in n8n
2. Verify Telegram token in environment vars
3. Check n8n execution log
4. Test with `/help` command

### Problem: "Session creation failed"

**Possible causes:**
- Google Sheets credentials invalid
- Sheet ID incorrect
- Sheet permissions wrong
- Sheet tabs missing

**Solutions:**
1. Verify GOOGLE_SHEET_ID in environment
2. Check credentials in n8n
3. Ensure sheet has 3 tabs with correct names
4. Share sheet with service account

### Problem: "Data validation failed"

**Possible causes:**
- Fields too short
- Missing required data
- No metrics/numbers
- Wrong sheet row

**Solutions:**
1. Check minimum lengths (see validation rules)
2. Fill all 3 columns
3. Include specific numbers
4. Ensure correct Why level row

### Problem: "Timeout - no response"

**This is normal!**
- Sessions wait 1 hour by default
- You can still respond after timeout
- Session stays active 24 hours
- Just reply `/ready[N]` when ready

### Problem: Claude API error

**Possible causes:**
- API key invalid
- Insufficient credits
- Rate limit exceeded
- API downtime

**Solutions:**
1. Check ANTHROPIC_API_KEY
2. Verify API credits in console
3. Wait a moment and retry
4. Check [Anthropic status](https://status.anthropic.com/)

---

## 📈 Best Practices

### For Best Results

1. **Take Your Time**
   - Quality over speed
   - Thorough data gathering
   - Don't rush through Whys

2. **Be Data-Driven**
   - Always validate with data
   - Include metrics
   - Show your evidence
   - Reference sources

3. **Stay Focused**
   - One session at a time
   - Complete all 5 Whys
   - Don't leave partially done
   - Use /status to track

4. **Collaborate**
   - Share sheet with team
   - Get input from experts
   - Review data together
   - Validate conclusions

5. **Document Well**
   - Clear, specific answers
   - Detailed data gathering
   - Explain your analysis
   - Link to sources

---

## 🎓 Training Resources

### Understanding 5 Whys

**What it is:**
- Iterative questioning technique
- Drill down to root cause
- Not about blame
- Focus on process/system issues

**How it works:**
1. State the problem
2. Ask "Why did this happen?"
3. Answer with data
4. Ask "Why?" again on that answer
5. Repeat 5 times
6. Identify root cause

**Example:**
```
Problem: Website is down
Why #1: Database server crashed
Why #2: Ran out of memory
Why #3: Memory leak in new code
Why #4: Code review didn't catch it
Why #5: No performance testing in CI/CD
Root Cause: Missing performance tests in pipeline
```

### Additional Reading

- [Toyota 5 Whys](https://en.wikipedia.org/wiki/Five_whys)
- [Root Cause Analysis Guide](https://asq.org/quality-resources/root-cause-analysis)
- [n8n Documentation](https://docs.n8n.io/)
- [Claude API Docs](https://docs.anthropic.com/)

---

## 🆘 Getting Support

### Self-Service

1. **Check this guide first**
2. **Use `/help` in bot**
3. **Use `/status` to debug**
4. **Review Google Sheet**
5. **Check n8n execution logs**

### Escalation

If still stuck:

1. **Collect information:**
   - Session ID
   - RCA Ticket
   - Error message
   - Screenshot
   - What you tried

2. **Contact your admin** with details

3. **Include n8n execution ID**
   - Found in Executions tab

---

## ✅ Pre-Launch Checklist

Before rolling out to your team:

**Setup:**
- [ ] Google Sheet created with 3 tabs
- [ ] Telegram bot created and tested
- [ ] Environment variables configured
- [ ] Credentials set up in n8n
- [ ] Workflow imported and activated

**Testing:**
- [ ] `/help` command works
- [ ] `/start5whys` creates session
- [ ] Problem statement validation works
- [ ] Why #1 question generated
- [ ] Data validation works
- [ ] All 5 Whys complete
- [ ] Final analysis generated
- [ ] Sheet updated correctly

**Documentation:**
- [ ] User guide shared with team
- [ ] Training session scheduled
- [ ] Example RCA shown
- [ ] Support process defined
- [ ] FAQs prepared

**Monitoring:**
- [ ] Execution logging enabled
- [ ] Error alerts configured
- [ ] Success metrics defined
- [ ] Review process established

---

## 🎉 You're Ready!

Your 5 Whys RCA workflow is now set up and ready to use.

**Next Steps:**
1. Run a test RCA session
2. Train your team
3. Start real analyses
4. Monitor and improve

**Questions?**
- Review `WORKFLOW_IMPROVEMENTS.md` for details
- Check n8n documentation
- Contact your workflow admin

**Happy analyzing!** 🔍🎯

---

**Version:** 2.0.0
**Last Updated:** 2024-11-19
**Estimated Setup Time:** 15 minutes
**Difficulty:** Easy
