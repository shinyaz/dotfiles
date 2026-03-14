---
name: creating-skill
description: Create a new Agent Skill following the agentskills.io standard. Use when the user wants to add a new skill, automate a recurring workflow, package reusable instructions for AI coding agents, or turn a conversation pattern into a repeatable procedure.
---

Create a new skill: $ARGUMENTS

## Skill Creation Workflow

1. **Determine skill details**
   - Name: gerund form (verb + -ing), kebab-case, 1-64 chars
   - Examples: `writing-posts`, `fixing-lint`, `debugging-build`
   - See [naming conventions](references/QUALITY-STANDARDS.md#naming-conventions) for full rules

2. **Create skill in both agent directories**
   ```bash
   mkdir -p .claude/skills/{skill-name}
   mkdir -p .kiro/skills/{skill-name}
   ```

3. **Create SKILL.md with frontmatter**
   ```yaml
   ---
   name: {skill-name}
   description: >-
     What it does + when to use it + keywords for agent discovery.
   ---
   ```
   See [description standards](references/QUALITY-STANDARDS.md#description-standards) — Claude undertriggers, so be pushy with "Use when ..." clauses.

4. **Write the body content**
   See [body content standards](references/QUALITY-STANDARDS.md#body-content-standards) and [templates](references/TEMPLATES.md) for patterns (workflow, knowledge, conditional, examples).

5. **Apply progressive disclosure** if SKILL.md approaches 500 lines
   - Move detailed reference material to `references/` directory
   - See [progressive disclosure rules](references/QUALITY-STANDARDS.md#progressive-disclosure)

6. **Copy to both agent directories**
   ```bash
   cp -r .claude/skills/{skill-name}/ .kiro/skills/{skill-name}/
   ```
   Claude Code specific skills (not shared) go only in `.claude/skills/`.

7. **Update CLAUDE.md skills list** (Claude Code only)
   ```markdown
   - `/{skill-name}` — Brief description
   ```
   Kiro auto-discovers skills from `.kiro/skills/`, no listing needed.

8. **Add context hints to CLAUDE.md** — Link the skill from relevant Critical Rules or workflow sections so Claude reaches for it in context:
   ```markdown
   - **Build must pass** — No warnings allowed. Build fails → `/debugging-build`
   ```

9. **Test the skill** — Try 2-3 realistic prompts to verify:
   - Does the skill trigger when expected?
   - Are the instructions clear enough for Claude to follow?
   - Does the output match expectations?
   - Adjust description or body based on observed behavior

## Validation Checklist

- [ ] `name` uses gerund form and matches directory name
- [ ] `description` has explicit "Use when ..." clause (pushy, not passive)
- [ ] Body is concise — no explanations Claude already knows
- [ ] SKILL.md under 500 lines — references 1 level deep
- [ ] Workflow skills have feedback loops and/or checklists
- [ ] No `git add -A` or auto-commit in workflow steps
- [ ] Exists in both `.claude/skills/` and `.kiro/skills/` (if shared)
- [ ] CLAUDE.md skills list updated with context hints
- [ ] Tested with 2-3 realistic prompts

See [quality standards](references/QUALITY-STANDARDS.md) for the full criteria used to audit skills.
