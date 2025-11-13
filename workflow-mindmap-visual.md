# Visual Mind Map - Ultimate Media Agent Workflow

## 🌳 Main Structure Tree

```
📱 TELEGRAM TRIGGER
│
├─ 🔀 SWITCH
│  ├─ 📸 Photo Branch
│  │  ├─ Download File
│  │  ├─ Upload to Google Drive
│  │  └─ Set Text Message
│  │
│  └─ 💬 Text Branch
│     └─ Pass Through
│
└─ 🤖 ULTIMATE MEDIA AGENT ⭐ [Main Orchestrator]
   │  └─ Models: GPT-5 mini (primary) + Fallback
   │  └─ Memory: Session-based (chat ID)
   │  └─ Special Tool: Think (for reasoning)
   │
   ├─────────────────────────────────────────────────────────┐
   │                                                           │
   ├─ 💾 GOOGLE DRIVE AGENT                                   │
   │  ├─ 🏷️  Change Name                                       │
   │  ├─ 🔍 Search Media (photos/videos)                      │
   │  ├─ 📄 Search Docs (analysis documents)                  │
   │  ├─ 📧 Share with Email                                  │
   │  └─ 🌐 Share with Anyone                                 │
   │                                                           │
   ├─ 📧 EMAIL AGENT                                          │
   │  ├─ 📤 Send Email                                        │
   │  ├─ 📥 Get Emails                                        │
   │  ├─ 📝 Create Draft                                      │
   │  ├─ 💬 Email Reply                                       │
   │  ├─ 🏷️  Get Labels                                        │
   │  ├─ 🏷️  Label Emails                                      │
   │  └─ 📬 Mark Unread                                       │
   │                                                           │
   ├─ 📅 CALENDAR AGENT                                       │
   │  ├─ ➕ Create Event                                       │
   │  ├─ 👥 Create Event with Attendee                        │
   │  ├─ 📋 Get Events                                        │
   │  ├─ ✏️  Update Event                                      │
   │  └─ ❌ Delete Event                                       │
   │                                                           │
   ├─ 👤 CONTACT AGENT ⚠️  [NEEDS FIX]                        │
   │  ├─ 🔍 Get Contacts (search)                             │
   │  ├─ ➕ Create a New ⚠️  [Broken: uses $fromAI()]          │
   │  ├─ ✏️  Add or Update (upsert)                           │
   │  └─ ❌ Delete                                             │
   │  └─ 💾 Backend: Airtable (Client Contacts base)         │
   │                                                           │
   ├─ 🎨 CREATIVE AGENT                                       │
   │  ├─ 🖼️  Edit Image (sub-workflow)                        │
   │  ├─ 🎨 Create Image (sub-workflow)                       │
   │  ├─ 🎬 Image to Video (sub-workflow)                     │
   │  └─ 🎥 Create Video (sub-workflow)                       │
   │     └─ All use external workflows                        │
   │                                                           │
   ├─ 📱 POSTING AGENT                                        │
   │  ├─ 📸 Instagram Post (sub-workflow)                     │
   │  ├─ 🐦 X/Twitter Post (sub-workflow)                     │
   │  └─ 🎵 TikTok Post (sub-workflow)                        │
   │     └─ All require Google Drive file ID                 │
   │                                                           │
   ├─ 🔍 SOCIAL MEDIA AGENT                                   │
   │  ├─ 📸 Instagram Search (Apify HTTP)                     │
   │  ├─ 📺 YouTube Search (Apify HTTP)                       │
   │  └─ 🎵 TikTok Search (Apify HTTP)                        │
   │                                                           │
   ├─ 🌐 WEB AGENT                                            │
   │  ├─ 🔮 Perplexity (deep research)                        │
   │  ├─ 🔎 Tavily (quick search) [MISSING IN CURRENT]       │
   │  ├─ 🤖 Google Gemini (AI queries)                        │
   │  └─ ☁️  OpenWeatherMap (weather data)                     │
   │                                                           │
   ├─ 📊 SHEET AGENT                                          │
   │  ├─ 📖 Get Rows (read data)                              │
   │  ├─ ➕ Append/Update Row (write data)                    │
   │  ├─ ❌ Delete Rows/Columns                               │
   │  ├─ 📋 Create Sheet                                      │
   │  └─ 💾 Backend: Google Sheets (Expense Tracker)         │
   │                                                           │
   └─ 📄 CREATE DOC (standalone workflow tool)                │
      └─ Creates Google Docs with title + content             │
                                                               │
                                                               │
   ┌───────────────────── OUTPUT ─────────────────────┐       │
   │                                                   │       │
   ├─ ✅ SUCCESS PATH                                  │       │
   │  ├─ Clean Up (extract tokens & steps)            │       │
   │  ├─ Update Log (Google Sheets logging)           │       │
   │  └─ 📱 Send Text Message (Telegram)              │       │
   │                                                   │       │
   └─ ❌ ERROR PATH                                    │       │
      ├─ Clean Up (extract error data)                │       │
      ├─ Update Log (mark as error)                   │       │
      └─ 📱 Error Message (Telegram)                  │       │
                                                       │       │
```

---

## 🎯 Agent Responsibility Matrix

| Agent | Primary Function | Tools Count | Backend | Model |
|-------|-----------------|-------------|---------|-------|
| **Ultimate Media Agent** | Orchestration & Routing | 10 agents | N/A | GPT-5 mini |
| **Google Drive** | File Management | 5 | Google Drive API | GPT-5 mini |
| **Email** | Email Operations | 7 | Gmail API | GPT-5 mini |
| **Calendar** | Event Management | 5 | Google Calendar | GPT-5 mini |
| **Contact** ⚠️ | Contact CRUD | 4 | Airtable | GPT-5 mini |
| **Creative** | Media Generation | 4 | Sub-workflows | GPT-5 mini |
| **Posting** | Social Publishing | 3 | Sub-workflows | GPT-5 mini |
| **Social Media** | Content Discovery | 3 | Apify | GPT-5 mini |
| **Web** | Research & Info | 4 | Multiple APIs | GPT-4.1 mini |
| **Sheet** | Spreadsheet Ops | 4 | Google Sheets | GPT-5 mini |

---

## 🔄 Information Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INTERACTION                          │
│                    (Telegram Chat)                          │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │   TELEGRAM TRIGGER    │
         └───────────┬───────────┘
                     │
         ┌───────────▼───────────┐
         │   CONTENT ROUTER      │
         │   (Switch Node)       │
         └─────┬──────────┬──────┘
               │          │
        Photo  │          │  Text
               │          │
         ┌─────▼──┐       │
         │Process │       │
         │& Upload│       │
         └────┬───┘       │
              └───────┬───┘
                      │
         ┌────────────▼─────────────┐
         │   ULTIMATE MEDIA AGENT   │◄─── Session Memory
         │   (Decision Maker)       │
         └────────────┬─────────────┘
                      │
         ┌────────────▼─────────────┐
         │  Analyzes Request &      │
         │  Selects Specialist      │
         └────────────┬─────────────┘
                      │
         ┌────────────▼─────────────┐
         │   SPECIALIST AGENTS      │
         │   (9 different types)    │
         └────────────┬─────────────┘
                      │
         ┌────────────▼─────────────┐
         │    EXECUTE ACTION        │
         │    (Tools/Workflows)     │
         └────────────┬─────────────┘
                      │
         ┌────────────▼─────────────┐
         │   PROCESS RESULTS        │
         │   (Clean & Log)          │
         └────────────┬─────────────┘
                      │
         ┌────────────▼─────────────┐
         │   RESPOND TO USER        │
         │   (Telegram Message)     │
         └──────────────────────────┘
```

---

## 🏗️ Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│  LAYER 1: INTERFACE                                          │
│  └─ Telegram (Input/Output)                                 │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│  LAYER 2: ROUTING                                            │
│  └─ Switch Node (Content Type Detection)                    │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│  LAYER 3: ORCHESTRATION                                      │
│  └─ Ultimate Media Agent (Task Delegation)                  │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│  LAYER 4: SPECIALIZATION                                     │
│  └─ 9 Specialized Agents (Domain Experts)                   │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│  LAYER 5: EXECUTION                                          │
│  └─ 40+ Tools & Workflows (Actions)                         │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│  LAYER 6: INTEGRATION                                        │
│  └─ External APIs (Google, Airtable, Apify, etc.)          │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│  LAYER 7: MONITORING                                         │
│  └─ Logging & Error Tracking (Google Sheets)               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎭 Agent Interaction Map

```
                    ULTIMATE MEDIA AGENT
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
    Workspace           Personal            Social
    Agents             Agents              Agents
        │                   │                   │
    ┌───┴───┐           ┌───┴───┐         ┌───┴───┐
    │       │           │       │         │       │
  Drive   Sheet      Email  Calendar   Creative Posting
    │       │           │       │         │       │
    │       │           │       └─────────┴───────┤
    │       │           └── Contact ⚠️            │
    │       │                                      │
    └───────┴──────────────────┬──────────────────┘
                               │
                          Social Media
                               &
                           Web Search
```

---

## ⚙️ Technical Configuration

### **Models Used**
- Primary: GPT-5 mini (OpenAI)
- Secondary: GPT-5 mini (OpenRouter)
- Research: GPT-4.1 mini (OpenRouter)
- Fallback: GPT-5 mini (OpenAI)

### **External Services**
- Google Drive
- Gmail
- Google Calendar
- Google Sheets
- Airtable
- Apify (Instagram, YouTube, TikTok scrapers)
- Perplexity
- Google Gemini
- OpenWeatherMap

### **Memory System**
- Type: Buffer Window Memory
- Key: Telegram Chat ID
- Scope: Per-conversation

### **Logging**
- Destination: Google Sheets ("Media Agent Logs")
- Captures: Timestamp, Input, Output, Actions, Tokens
- Error Tracking: Separate log entries with execution ID

---

## 🔴 Critical Issue Highlighted

```
┌────────────────────────────────────────────────────┐
│  ⚠️  CONTACT AGENT - "Create a New" Tool           │
│                                                     │
│  Problem:                                          │
│  └─ Uses $fromAI() expressions                    │
│  └─ Fails to extract structured data              │
│  └─ Cannot properly create contacts               │
│                                                     │
│  Impact:                                           │
│  └─ Contact creation fails silently               │
│  └─ Empty fields in Airtable                      │
│  └─ User frustration                              │
│                                                     │
│  Solution Files Created:                           │
│  ✅ contact-agent-solution-1.json                  │
│  ✅ contact-agent-solution-2.json (RECOMMENDED)    │
│  ✅ contact-agent-solution-3.json                  │
│  ✅ contact-solutions-comparison.md                │
└────────────────────────────────────────────────────┘
```

---

## 📈 Scalability Considerations

### **Current Strengths**
✅ Modular agent design
✅ Reusable sub-workflows
✅ Comprehensive logging
✅ Memory-enabled

### **Potential Improvements**
🔧 Break into smaller workflows (currently 89 nodes)
🔧 Add more error handling
🔧 Implement retry logic
🔧 Add rate limiting
🔧 Create agent health checks

---

## 🎨 Color-Coded Priority Map

```
🟢 GREEN (Working Well)
├─ Google Drive Agent
├─ Email Agent
├─ Calendar Agent
├─ Creative Agent
├─ Posting Agent
├─ Social Media Agent
├─ Web Agent
└─ Sheet Agent

🟡 YELLOW (Needs Attention)
├─ Error handling could be better
├─ Complexity management (89 nodes)
└─ Some agents lack validation

🔴 RED (Critical Issue)
└─ Contact Agent "Create a New" tool ⚠️
    └─ Fix with Solution 2 recommended
```
