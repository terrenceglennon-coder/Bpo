# n8n Email Automation Workflow Analysis

## Overview
This is an AI-powered email management system that automatically categorizes incoming Gmail messages and responds with different AI agents based on the email category.

---

## Workflow Architecture

### Trigger
- **Gmail Trigger** - Polls Gmail every minute for new emails
- Retrieves: Subject, Snippet (preview), From, ThreadId, MessageId

### Classification Engine
- **Text Classifier** (LangChain node)
- Uses OpenAI GPT-3.5-turbo model
- Classifies emails into 7 categories using email subject + snippet

---

## Email Categories & Actions

### 1. **Customer Support**
**Classification Keywords**: help, issue, support, error, reset, fix, login, troubleshoot, can't, question, not working

**Flow**:
1. Adds Gmail label "Support"
2. Triggers **Customer Support Agent** (AI)
3. Auto-replies to the email

**AI Personality**:
- Expert, friendly, and professional
- Acts as representative for "Glennons Inc"
- Provides accurate information about AI Automation Society
- Signs off as "Terry's AI Assistant"
- Redirects unknown queries to: Terrenceglennon@gmail.com

---

### 2. **Finance/Billing**
**Classification Keywords**: invoice, refund, payment, billing, subscription, charge, receipt, overcharged, decline, failed transaction, cancel, renewal

**Flow**:
1. Adds Gmail label "Finance"
2. Forwards notification email to: Tag@terryglennon.org

**Notification Format**:
```
Subject: New Billing Email: [Sender Name]
Body:
- Timestamp
- Sender name & email
- Original subject
```

**Note**: No auto-reply; billing team handles manually

---

### 3. **High Priority**
**Classification Keywords**: urgent, ASAP, emergency, escalation, outage, down, broken, immediately, help now, fix fast

**Flow**:
1. Adds Gmail label "Priority"
2. Triggers **Mr. Doomsday Agent** (AI)
3. Creates a DRAFT reply (does not auto-send)

**AI Personality**:
- Brutally honest and rude
- Sarcastic, blunt, unapologetically rude tone
- Still provides accurate information
- Makes it clear if someone asks obvious questions
- Signs off as "Mr. Doomsday"

**Note**: Draft created for human review before sending

---

### 4. **Promotion**
**Classification Keywords**: sale, discount, offer, promotion, upgrade, exclusive, feature, join now, limited time, access now, new launch

**Flow**:
1. Adds Gmail label "Promotion"
2. Marks email as read
3. No reply sent (automated cleanup)

---

### 5. **Family** (Highest Priority Override)
**Classification Keywords**: hi, hey, how are you, family, friend, catching up, love, miss you, birthday, update, just checking in, weekend, Mom, Dad

**Special Rule**: "Family has precedence over all other categories"

**Flow**:
1. Adds Gmail label "Family"
2. Triggers **Family Agent** (AI)
3. Auto-replies to sender

**AI Personality**:
- Helpful, warm, and personable
- Drafts thoughtful, casual, caring replies
- Reflects Terry's authentic tone
- Includes empathy, familiarity, light humor
- Uses informal, natural language
- Can use emojis (😊 👍)
- Signs off as "Terry's AI Assistant"

**Special Feature**: Agent structured to send dual output:
- `email_reply`: Full message for email
- `telegram_note`: Short summary/urgent note for Telegram (tool not currently connected)

---

### 6. **LinkedIn**
**Classification Keywords**: LinkedIn, job alert, opportunity, connection, message, recruiter, profile, network, hiring, suggested, update, post, invite

**Special Rule**: "If it has the word LinkedIn classify as LinkedIn over any other"

**Flow**:
1. Adds Gmail label "LinkedIn"
2. Triggers **LinkedIn Agent** (AI)
3. Auto-replies ONLY to personal messages

**AI Personality**:
- Smart and organized
- Professional, friendly, approachable
- Most LinkedIn emails are automated → No reply needed
- Only replies to genuine personal outreach
- Politely declines generic pitches
- Never shares personal info or makes commitments

---

### 7. **Uncategorized**
**Classification**: Catch-all for unclear/vague emails

**Flow**:
1. Adds Gmail label "Uncategorized"
2. Triggers **Uncategorized Agent** (AI)
3. Auto-replies asking for clarification

**AI Personality**:
- Thoughtful, polite, attentive
- Acknowledges receipt
- Asks friendly follow-up questions to clarify intent
- Neutral, respectful, approachable tone
- Does not make assumptions
- Uses soft emojis (🤔 👋)
- Signs off as "Terry's AI Assistant"

---

## AI Models Used

### Text Classifier
- **Model**: OpenAI GPT-3.5-turbo
- **Purpose**: Email categorization

### All AI Agents
- **Model**: OpenAI GPT-4.1-mini
- **Purpose**: Email response generation
- **Agents**: Customer Support, Mr. Doomsday, Family, Uncategorized, LinkedIn

---

## Workflow Flow Diagram

```
Gmail Trigger (every minute)
    ↓
Text Classifier (AI categorization)
    ↓
[Routes to 7 branches]
    ↓
┌────────────────┬──────────────┬─────────────┬────────────┬─────────┬──────────────┬──────────┐
│   Support      │   Finance    │  Priority   │ Promotion  │ Family  │ Uncategorized│ LinkedIn │
│   (Label)      │   (Label)    │   (Label)   │  (Label)   │ (Label) │   (Label)    │ (Label)  │
│      ↓         │      ↓       │      ↓      │     ↓      │    ↓    │      ↓       │    ↓     │
│ Support Agent  │ Forward to   │ Mr.Doomsday │  Mark Read │ Family  │ Uncategorized│ LinkedIn │
│      ↓         │  Billing     │      ↓      │            │  Agent  │    Agent     │  Agent   │
│  Auto-Reply    │              │ Create Draft│            │    ↓    │      ↓       │    ↓     │
│                │              │             │            │  Reply  │    Reply     │  Reply   │
└────────────────┴──────────────┴─────────────┴────────────┴─────────┴──────────────┴──────────┘
```

---

## Key Features

### 1. **Intelligent Routing**
- Single entry point processes all emails
- AI-powered classification ensures accurate categorization
- Different handling strategies per category

### 2. **Multiple AI Personas**
- 5 distinct AI agents with different personalities
- Each tailored to specific email types
- Ranges from friendly support to brutally honest

### 3. **Safety Mechanisms**
- High priority emails create drafts (not auto-send)
- Finance emails forwarded to team
- Promotional emails auto-archived
- Family emails get highest precedence

### 4. **Gmail Integration**
- Automatic labeling for organization
- Reply/Draft capabilities
- Mark as read functionality
- Thread-aware responses

---

## Potential Improvements

### 1. **Missing Telegram Integration**
- Family Agent references Telegram tool but it's not connected
- Could send notifications for important family emails

### 2. **No Error Handling**
- No fallback if AI agents fail
- No retry logic for Gmail API failures

### 3. **Cost Optimization**
- Uses GPT-4.1-mini for all agents (cost-effective)
- Could optimize classifier to use smaller model

### 4. **Rate Limiting**
- Polls every minute
- Could be optimized with webhooks instead

### 5. **Logging/Monitoring**
- No audit trail of AI decisions
- No tracking of response quality

### 6. **Human-in-the-Loop**
- Only Priority uses drafts
- Other categories auto-send without review

---

## Security Considerations

### ✅ Good Practices
- Agents instructed not to share personal info
- Unknown queries redirected to real email
- Finance emails handled by humans
- Priority emails reviewed before sending

### ⚠️ Potential Risks
- Auto-replies without human review (most categories)
- AI hallucinations could send incorrect info
- No content filtering for sensitive data
- Full Gmail access for automation

---

## Credentials Used
- **Gmail OAuth2**: Connected to Terry's Gmail account
- **OpenAI API**: For GPT-3.5-turbo and GPT-4.1-mini

---

## Summary

This is a sophisticated personal email automation system that:
- Saves time by automatically triaging emails
- Provides context-appropriate responses
- Maintains different communication styles per audience
- Integrates tightly with Gmail workflow
- Uses modern AI agents for natural language processing

**Best suited for**: High-volume email users who want intelligent automation but maintain brand consistency across different email types.

**Primary user**: Terry Glennon (Glennons Inc / AI Automation Society)
