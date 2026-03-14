# Skill Quality Standards

Shared criteria for creating and auditing skills. Referenced by both `/creating-skill` and `/optimizing-agent-instructions`.

## Contents

- [Naming Conventions](#naming-conventions)
- [Description Standards](#description-standards)
- [Body Content Standards](#body-content-standards)
- [Progressive Disclosure](#progressive-disclosure)
- [CLAUDE.md Standards](#claudemd-standards)

## Naming Conventions

**Recommended:** gerund form (verb + -ing)
- `processing-pdfs`, `analyzing-data`, `writing-posts`

**Acceptable alternatives:**
- Noun phrases: `pdf-processing`, `data-analysis`
- Action-oriented: `process-pdfs`, `analyze-data`

**Avoid:**
- Vague: `helper`, `utils`, `tools`
- Too generic: `documents`, `data`, `files`
- Reserved words: `anthropic-*`, `claude-*`

**Rules:**
- Lowercase, numbers, hyphens only (max 64 chars)
- No leading/trailing hyphens, no consecutive hyphens (`--`)
- Consistency within the collection is the most important rule

## Description Standards

Claude tends to undertrigger skills, so descriptions should be pushy.

**Structure:** What it does (1-2 sentences) + "Use when ..." clause with specific triggers.

**Rules:**
- Third person only (not "I help" or "You can use")
- Must include explicit "Use when ..." with specific trigger conditions
- Include casual/edge-case phrasing users might actually type
- Max 1024 chars, no XML tags

**Examples:**

Bad:
- `Helps with PDFs.` (vague, no triggers)
- `Loaded when editing posts.` (passive, no "Use when")

Good:
```
Extracts text and tables from PDF files, fills PDF forms,
and merges multiple PDFs. Use when working with PDF documents
or when the user mentions PDFs, forms, or document extraction.
```

Better (pushy, covers edge cases):
```
Blog post writing guidelines and creation workflow. Covers title,
description, structure, voice, and bilingual conventions. Use when
the user wants to write a new blog post, asks about post format
or structure, edits files in content/posts/, or mentions writing
an article. Even if the user just says "write about X" or gives
a topic, use this skill to guide the post creation.
```

## Body Content Standards

- **Be concise** — Claude is already smart. Only add context it doesn't have (project-specific knowledge, exact commands, domain conventions). Challenge each paragraph: "Does Claude really need this?"
- **Explain the why** — Instead of rigid MUSTs, explain reasoning so Claude can adapt to edge cases
- **Match freedom to fragility** — Fragile operations (DB migrations, deployments) need exact scripts. Flexible tasks (code review, writing) need general direction
- **Include feedback loops** for quality-critical workflows: run validator → fix errors → repeat
- **Add checklists** for multi-step workflows so Claude can track progress
- Do NOT include `git add -A` or auto-commit steps
- Avoid time-sensitive information ("before August 2025, use X")
- Use consistent terminology — pick one term per concept and stick with it

## Progressive Disclosure

```
skill-name/
├── SKILL.md              # Overview + navigation (under 500 lines)
├── references/           # Detailed docs (loaded on demand, 1 level deep)
└── scripts/              # Executable code (run, not loaded into context)
```

- SKILL.md body under 500 lines
- References must link **directly from SKILL.md** — never chain (A → B → C)
- Add table of contents to reference files over 100 lines
- Scripts are executed, not read into context (saves tokens)

## CLAUDE.md Standards

### Target size
- Excellent: <50 lines
- Good: 50-100 lines
- Needs work: 100-200 lines
- Poor: >200 lines

### What stays in CLAUDE.md

| Include | Exclude |
|---------|---------|
| Bash commands the agent can't guess | What the agent can understand from reading code |
| Code style rules that differ from defaults | Standard language conventions |
| Test instructions and recommended runners | Detailed API documentation (link instead) |
| Repo etiquette (branch naming, PR conventions) | Frequently changing information |
| Project-specific architecture decisions | Long explanations or tutorials |
| Dev environment quirks (required env vars) | File-by-file codebase descriptions |
| Common pitfalls or non-obvious behavior | Self-evident practices like "write clean code" |

### What becomes a skill
- Multi-step procedures (5+ steps)
- Build/test/deploy workflows
- Content creation guides
- Debugging procedures
- Domain knowledge not needed every session

### Content flags

**Red flags** (definitely remove from CLAUDE.md):
- Step-by-step procedures (5+ steps → extract to skill)
- Detailed API documentation
- Generic best practices the agent already knows
- File-by-file codebase descriptions
- Long explanations or tutorials

**Yellow flags** (consider removing):
- Examples that could be inferred from code
- Standard language conventions
- Verbose descriptions
- Duplicate information

**Green flags** (keep):
- Project-specific constraints
- Non-obvious commands
- Custom build/test commands
- Language rules (e.g., "respond in Japanese")
- Critical warnings and common pitfalls
- Repo etiquette (branch naming, PR conventions)
