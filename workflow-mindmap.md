# Ultimate Media Agent Workflow - Mind Map

```
                                    📱 TELEGRAM TRIGGER
                                            |
                                    [Switch: Photo/Text]
                                      /            \
                              Photo Path          Text Path
                                  |                   |
                          Download File               |
                                  |                   |
                          Upload to Drive             |
                                  |                   |
                              Set Text                |
                                   \                 /
                                    \               /
                                     \             /
                                      \           /
                                       \         /
                                        \       /
                                ┌────────────────────┐
                                │                    │
                        🤖 ULTIMATE MEDIA AGENT (GPT-5 mini)
                                │                    │
                                │  [Memory: Session] │
                                │  [Think Tool]      │
                                └────────────────────┘
                                          |
                    ┌─────────────────────┼─────────────────────┐
                    |                     |                     |
            ┌───────┴────────┐   ┌────────┴─────────┐  ┌──────┴────────┐
            |                |   |                  |  |               |
    ┌───────────────┐  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐
    │ GOOGLE DRIVE  │  │    EMAIL     │  │  CALENDAR    │  │  CONTACT    │
    │    AGENT      │  │    AGENT     │  │   AGENT      │  │   AGENT     │
    │ (GPT-5 mini)  │  │(GPT-5 mini)  │  │(GPT-5 mini)  │  │(GPT-5 mini) │
    └───────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬──────┘
            │                 │                  │                 │
       ┌────┴────┐       ┌────┴────┐       ┌────┴────┐       ┌────┴────┐
       │ Tools:  │       │ Tools:  │       │ Tools:  │       │ Tools:  │
       │         │       │         │       │         │       │         │
       │• Change │       │• Send   │       │• Create │       │• Get    │
       │  Name   │       │  Email  │       │  Event  │       │  Contacts│
       │• Search │       │• Get    │       │• Get    │       │• Create │
       │  Media  │       │  Emails │       │  Events │       │  New    │
       │• Search │       │• Create │       │• Delete │       │• Update │
       │  Docs   │       │  Draft  │       │  Event  │       │• Delete │
       │• Share  │       │• Reply  │       │• Update │       │         │
       │  Email  │       │• Get    │       │  Event  │       └─────────┘
       │• Share  │       │  Labels │       │• Create │
       │  Anyone │       │• Label  │       │  w/Guest│
       │         │       │  Emails │       │         │
       └─────────┘       │• Mark   │       └─────────┘
                         │  Unread │
                         └─────────┘


    ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
    │   CREATIVE   │  │   POSTING    │  │    SOCIAL    │  │     WEB      │
    │    AGENT     │  │    AGENT     │  │    MEDIA     │  │    AGENT     │
    │(GPT-5 mini)  │  │(GPT-5 mini)  │  │    AGENT     │  │(GPT-4.1 mini)│
    └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
           │                 │                  │                 │
      ┌────┴────┐       ┌────┴────┐       ┌────┴────┐       ┌────┴────┐
      │ Tools:  │       │ Tools:  │       │ Tools:  │       │ Tools:  │
      │         │       │         │       │         │       │         │
      │• Edit   │       │• Insta  │       │• Insta  │       │• Perp-  │
      │  Image  │       │  Post   │       │  Search │       │  lexity │
      │• Create │       │• X Post │       │• YouTube│       │• Tavily │
      │  Image  │       │• TikTok │       │  Search │       │• Google │
      │• Image  │       │  Post   │       │• TikTok │       │  Gemini │
      │  to     │       │         │       │  Search │       │• Weather│
      │  Video  │       │         │       │         │       │         │
      │• Create │       │         │       │         │       │         │
      │  Video  │       │         │       │         │       │         │
      └─────────┘       └─────────┘       └─────────┘       └─────────┘


    ┌──────────────┐  ┌──────────────┐
    │    SHEET     │  │   CREATE     │
    │    AGENT     │  │     DOC      │
    │(GPT-5 mini)  │  │  (Workflow)  │
    └──────┬───────┘  └──────────────┘
           │
      ┌────┴────┐
      │ Tools:  │
      │         │
      │• Get    │
      │  Rows   │
      │• Append/│
      │  Update │
      │• Delete │
      │  Rows   │
      │• Create │
      │  Sheet  │
      └─────────┘


                        OUTPUT FLOW:
                              │
                    ┌─────────┴──────────┐
                    │                    │
              [Success Path]      [Error Path]
                    │                    │
              Clean Up Node        Clean Up Node
                    │                    │
              Update Log           Update Log
                    │                    │
              Send Message         Error Message
                    ▼                    ▼
              📱 TELEGRAM          📱 TELEGRAM
```

---

## 🎯 Workflow Architecture Summary

### **Entry Point**
- **Telegram Trigger** → Receives messages (text or photos)
- **Switch Node** → Routes to photo processing or direct to agent

### **Core Orchestrator**
- **Ultimate Media Agent** (GPT-5 mini)
  - Main decision maker
  - Delegates to specialized agents
  - Memory-enabled (session-based)
  - Has "Think" tool for complex reasoning

### **9 Specialized Agents**

#### 1️⃣ **Google Drive Agent**
   - File management
   - Search, rename, share
   - 5 tools

#### 2️⃣ **Email Agent**
   - Gmail operations
   - Send, draft, reply, label
   - 7 tools

#### 3️⃣ **Calendar Agent**
   - Google Calendar
   - CRUD operations
   - 5 tools

#### 4️⃣ **Contact Agent** ⚠️ (NEEDS FIX)
   - Airtable contacts
   - Create, read, update, delete
   - 4 tools
   - **Problem**: Create tool uses unreliable $fromAI()

#### 5️⃣ **Creative Agent**
   - Image/Video generation
   - Edit, create, transform
   - 4 workflow tools (external workflows)

#### 6️⃣ **Posting Agent**
   - Social media posting
   - Instagram, X (Twitter), TikTok
   - 3 workflow tools

#### 7️⃣ **Social Media Agent**
   - Content search
   - Instagram, YouTube, TikTok
   - 3 HTTP tools (Apify scrapers)

#### 8️⃣ **Web Agent**
   - Research & information
   - Perplexity, Tavily, Google Gemini, Weather
   - 4 tools

#### 9️⃣ **Sheet Agent**
   - Google Sheets operations
   - CRUD operations
   - 4 tools
   - Special: Expense Tracker integration

### **Output Handling**
- **Success Path**: Clean Up → Log → Send to Telegram
- **Error Path**: Clean Up → Log Error → Send Error to Telegram

### **Supporting Infrastructure**
- **Memory**: Session-based (chat ID)
- **Logging**: Google Sheets tracking (tokens, actions, timestamps)
- **Models**: Mix of GPT-5 mini, GPT-4.1 mini
- **Fallbacks**: OpenAI API as backup

---

## 📊 Workflow Statistics

- **Total Nodes**: 89
- **AI Agents**: 10 (1 main + 9 specialized)
- **Tools Available**: 40+
- **External Workflows**: 6
- **API Integrations**: 10+
- **Language Models**: 2 types

---

## 🔄 Data Flow Pattern

```
User Input → Telegram
    ↓
Switch (Photo/Text)
    ↓
Ultimate Media Agent (decides action)
    ↓
Specialized Agent (executes task)
    ↓
Tool/Workflow (performs operation)
    ↓
Clean Up & Log
    ↓
Response → Telegram
```

---

## ⚠️ Known Issues

1. **Contact Agent - Create Tool**
   - Uses $fromAI() which fails to extract data properly
   - Recommended fix: Solution 2 (Structured Output)

2. **Complexity**
   - 89 nodes makes debugging challenging
   - Consider splitting into smaller workflows

3. **Error Handling**
   - Error path exists but could be more robust
   - Some agents lack proper validation

---

## 💡 Strengths

✅ Highly modular with specialized agents
✅ Memory-enabled for context retention
✅ Comprehensive logging
✅ Multi-platform integration
✅ Creative capabilities (image/video)
✅ Dual LLM setup with fallbacks

---

## 🎨 Hierarchical View

```
Level 0: Telegram Trigger
Level 1: Ultimate Media Agent (Orchestrator)
Level 2: 9 Specialized Agents
Level 3: 40+ Individual Tools
Level 4: External APIs & Services
```
