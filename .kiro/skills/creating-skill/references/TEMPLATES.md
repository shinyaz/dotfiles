# Create Skill — Templates and Conventions

## Full Frontmatter Schema

```yaml
---
name: {skill-name}          # Required. Must match directory name
description: >-              # Required. Max 1024 chars
  What it does + when to use it + keywords for agent discovery.
license: MIT                 # Optional
compatibility: ""            # Optional. Environment requirements
metadata:                    # Optional. Arbitrary key-value pairs
  author: ""
  version: "1.0"
---
```

For naming rules and description best practices, see [QUALITY-STANDARDS.md](QUALITY-STANDARDS.md).

## Body Content Templates

### Workflow skill (with checklist and feedback loop):

````markdown
{Description}: $ARGUMENTS

Copy this checklist to track progress:

```
Task Progress:
- [ ] Step 1: Do X
- [ ] Step 2: Validate X
- [ ] Step 3: Do Y
```

## Workflow

1. **Step name**
   - Detail
   ```bash
   command if needed
   ```

2. **Validate**
   ```bash
   validation command
   ```
   If validation fails, fix and re-run before continuing.
````

### Knowledge skill:

```markdown
## Key Information
- Point 1
- Point 2

## Guidelines
[Domain-specific knowledge]
```

### Conditional workflow skill:

```markdown
## Workflow

1. Determine the task type:

   **Creating new?** → Follow "Creation workflow" below
   **Editing existing?** → Follow "Editing workflow" below

2. Creation workflow:
   - Step A
   - Step B

3. Editing workflow:
   - Step C
   - Step D
```

### Examples pattern (for output-format-sensitive skills):

````markdown
## Format

**Example 1:**
Input: Added user authentication with JWT tokens
Output:
```
feat(auth): implement JWT-based authentication
```

**Example 2:**
Input: Fixed bug where dates displayed incorrectly
Output:
```
fix(reports): correct date formatting in timezone conversion
```
````

## Skill Types

| Type | Examples | Characteristics |
|------|----------|-----------------|
| Workflow | writing-posts, fixing-lint | Step-by-step procedures, checklists, feedback loops |
| Diagnostic | debugging-build | Problem identification, solutions |
| Knowledge | api-conventions | Reference info, best practices |
| Validation | syncing-i18n | Check procedures, reporting |

## Optional Directories

```
skill-name/
├── SKILL.md              # Required
├── scripts/              # Executable code agents can run
├── references/           # Additional documentation loaded on demand (1 level deep)
└── assets/               # Templates, images, data files
```

References must link directly from SKILL.md — never chain references from other reference files.
