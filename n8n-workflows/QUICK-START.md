# Quick Start Guide - Optimized Email Automation

Get your optimized n8n email automation running in 15 minutes!

## ⚡ Fast Track Setup

### 1. Import Workflows (5 min)

Import in this exact order:

```
1. utilities/error-handler.json
2. agents/customer-support-agent.json
3. agents/mr-doomsday-agent.json
4. agents/family-agent.json
5. agents/uncategorized-agent.json
6. agents/linkedin-agent.json
7. main/email-automation-main.json  ← LAST!
```

**How to import:**
- n8n → Workflows → "..." menu → Import from File
- Select JSON file
- Click Import

### 2. Update Credentials (5 min)

**Gmail OAuth2** (needed in 8 places):
- Main workflow: Gmail Trigger + 7 Label nodes
- Each agent: 1 Gmail node
- Error handler: 1 Gmail node

**OpenAI API** (needed in 6 places):
- Main workflow: 1 OpenAI Chat Model
- Each of 5 agents: 1 OpenAI Chat Model

**Quick method:**
1. Click any Gmail node → "Credential to connect with"
2. Create new Gmail OAuth2 credential (authenticate once)
3. For other nodes, select the same credential from dropdown
4. Repeat for OpenAI API

### 3. Link Sub-Workflows (3 min)

In the **main workflow**, update these 5 nodes:

1. **Call Support Agent** → Select `Customer Support Agent` workflow
2. **Call Mr. Doomsday Agent** → Select `Mr. Doomsday Agent` workflow
3. **Call Family Agent** → Select `Family Agent` workflow
4. **Call Uncategorized Agent** → Select `Uncategorized Agent` workflow
5. **Call LinkedIn Agent** → Select `LinkedIn Agent` workflow

### 4. Update Label IDs (2 min)

**Get your label IDs:**

Create a quick test workflow:
```
Gmail → Get Labels node → Execute
```

Copy your label IDs, then update these 7 nodes in main workflow:
- Label: Support
- Label: Finance
- Label: Priority
- Label: Promotion
- Label: Family
- Label: Uncategorized
- Label: LinkedIn

### 5. Activate & Test! (5 min)

1. Click "Active" toggle on main workflow
2. Send yourself test emails:
   - "Help! My login isn't working" → Should go to Support
   - "Hi Mom, how are you?" → Should go to Family
   - Email from linkedin.com → Should go to LinkedIn
3. Wait 5 minutes (polling interval)
4. Check Gmail for labels and replies
5. Check n8n Executions tab for logs

---

## ✅ Success Checklist

After setup, you should see:

- [ ] Main workflow is Active
- [ ] All 5 agent workflows are Active
- [ ] Error handler workflow is Active
- [ ] Test email received and classified
- [ ] Gmail label applied correctly
- [ ] AI agent replied (if expected)
- [ ] No errors in Executions log

---

## 🚨 Common Issues

### "Workflow not found" error
→ Make sure sub-workflows are imported AND activated

### "Authentication failed"
→ Re-authenticate Gmail OAuth2 (credentials may have expired)

### "OpenAI API error"
→ Check API key is valid and has credits

### No emails being processed
→ Wait at least 5 minutes (polling interval)

### Wrong labels applied
→ Double-check label IDs match your Gmail labels

---

## 🎯 What Happens Next?

Once activated, the workflow will:

1. **Every 5 minutes**: Check Gmail for new emails
2. **Pre-filter**: Skip AI for obvious categories (LinkedIn, Promotions)
3. **Classify**: Use AI to categorize unclear emails
4. **Label**: Apply Gmail label based on category
5. **Respond**: Call appropriate AI agent to reply/draft

---

## 📊 Expected Results (100 emails/day)

- **Cost**: $20-30/month (vs $150-200 before)
- **Speed**: 5-10 second responses (vs 30-60 seconds)
- **Executions**: ~300/day (vs 1,440)
- **Accuracy**: 90-95% correct classification

---

## 🔧 Quick Tweaks

### Make it faster
Change Gmail Trigger polling to every 2 minutes:
```
Main workflow → Gmail Trigger → pollTimes → minute: 2
```

### Make it cheaper
Already using GPT-4o-mini (cheapest option!)
To save more: Increase polling to every 10 minutes

### Make it smarter
Add more categories in Text Classifier node:
```
Main workflow → Text Classifier → Categories → Add category
```

---

## 📚 Next Steps

After basic setup works:

1. **Week 1**: Monitor daily, adjust prompts
2. **Week 2**: Fine-tune categories based on errors
3. **Week 3**: Add Telegram alerts (optional)
4. **Week 4**: Optimize polling frequency for your volume

---

## 💡 Pro Tips

- Keep old workflow as backup (rename to "BACKUP")
- Start with 10-minute polling, decrease gradually
- Review Mr. Doomsday drafts before sending!
- Check execution logs weekly
- Export workflows monthly for backup

---

## 🆘 Need Help?

Check the full README.md for:
- Detailed troubleshooting
- Advanced configuration
- Monitoring & analytics
- Customization guide

---

**You're all set! 🎉**

Your emails will now be automatically classified and responded to by AI agents, saving you hours every week!
