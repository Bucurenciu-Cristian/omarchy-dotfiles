---
name: client-feedback-chat
description: Use when setting up client communication tracking, creating chat.md files, parsing WhatsApp feedback, or organizing client requests. Triggers on "client feedback", "whatsapp chat", "chat.md", "client communication", "track client requests".
---

# Client Feedback Chat Setup

## Overview

This skill sets up a `chat.md` file system for tracking client communication from WhatsApp or other messaging apps. It provides a structured way to capture raw messages, extract action items, and track progress.

**Announce at start:** "I'm using the client-feedback-chat skill to set up communication tracking."

## When to Use

- Setting up a new client project
- Client sends feedback via WhatsApp/messaging
- Need to organize scattered client requests
- Want to track action items from conversations

## Implementation

### Step 1: Create `chat.md` in Project Root

```markdown
# Client Feedback Chat

This file contains the original feedback text from the client. Copy-paste WhatsApp messages here to track requests, decisions, and action items.

---

## Session: [DATE RANGE] ([Client Name])

```
[Paste raw WhatsApp chat here with timestamps]
```

---

## Extracted Action Items

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | [Task description] | ⏳ TODO | |

Status markers: ⏳ TODO | 🔄 IN PROGRESS | ✅ DONE

---

## Specific Data Extracted

[Tables, schedules, or structured data extracted from chat]
```

### Step 2: Add to `.gitignore`

Add this line to keep client communication private:

```
# Client feedback chat (not for version control)
chat.md
```

### Step 3: Document in CLAUDE.md (Optional)

If the project has a CLAUDE.md, add a note:

```markdown
## Client Communication

Client feedback is tracked in `chat.md` (git-ignored). When working on client requests:
1. Check `chat.md` for context and action items
2. Update status markers as tasks progress
3. Add new sessions when receiving fresh feedback
```

## Usage Workflow

When receiving WhatsApp feedback:

1. **Capture** - Copy raw messages (with timestamps) into a new session block
2. **Parse** - Read through and identify actionable items
3. **Extract** - Update the "Extracted Action Items" table
4. **Organize** - Pull out structured data (schedules, specs) into separate sections
5. **Track** - Mark items as: ⏳ TODO | 🔄 IN PROGRESS | ✅ DONE

## Session Block Template

For each new batch of client messages:

```markdown
---

## Session: Jan 15-19, 2026 (Client Name)

```
[15/01/26, 10:23] Client: Hey, can we add a dark mode?
[15/01/26, 10:24] Client: Also the button on the homepage is too small
[16/01/26, 14:30] Client: Actually, make the button blue instead
[19/01/26, 09:15] Client: Perfect! One more thing - can we add a contact form?
```

### Action Items from this Session

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Add dark mode toggle | ⏳ TODO | |
| 2 | Increase homepage button size | ✅ DONE | Changed to 48px |
| 3 | Change button color to blue | ✅ DONE | Using brand blue #0066CC |
| 4 | Add contact form | ⏳ TODO | Need to clarify fields needed |
```

## Parsing Tips

When parsing WhatsApp chats:

- **Look for questions** → May need clarification before action
- **Look for "can we" / "could you"** → Direct requests
- **Look for decisions** → Update previous conflicting requests
- **Look for dates/times** → Extract into schedules
- **Look for lists** → Extract into tables
- **Look for approvals** → Mark related items as confirmed

## Integration with Task Management

After extracting items, you can:

1. Create GitHub issues from action items
2. Add to project TODO list
3. Reference in commit messages: `feat: add dark mode (chat.md #1)`
