---
name: optimizing-agent-instructions
description: Analyze and optimize CLAUDE.md and skill files for quality, conciseness, and adherence to best practices. Generates reports and applies improvements. Use when CLAUDE.md grows beyond 100 lines, after adding new skills, when reviewing agent instruction quality, or when the user mentions optimizing, analyzing, or auditing skills or CLAUDE.md.
---

Analyze and optimize agent instructions (CLAUDE.md and skills): $ARGUMENTS

Copy this checklist to track progress:

```
Optimization Progress:
- [ ] Phase 1: Analyze — measure, audit, report
- [ ] Phase 2: Optimize — CLAUDE.md, skills, descriptions
- [ ] Phase 3: Sync to Kiro
- [ ] Phase 4: Validate
```

## Phase 1: Analyze

### 1.1 Measure CLAUDE.md

```bash
wc -l CLAUDE.md
```

For each line/section, ask:
- Would removing this cause the agent to make a mistake?
- Is this used in every session?
- Can the agent figure this out from context?
- Is this project-specific?

See [CLAUDE.md standards](references/QUALITY-STANDARDS.md#claudemd-standards) for target sizes and content flags.

### 1.2 Audit skills

```bash
for f in .claude/skills/*/SKILL.md; do
  printf "%-50s %s lines\n" "$f" "$(wc -l < "$f")"
done
```

For each skill, check against [quality standards](references/QUALITY-STANDARDS.md):
- Name uses gerund form, matches directory
- Description is third person with "Use when ..." clause
- SKILL.md body under 500 lines
- References 1 level deep, TOC for 100+ line files
- No time-sensitive information

### 1.3 Generate analysis report

```markdown
## Agent Instructions Analysis Report

### CLAUDE.md
- Lines: {count} — {status per target sizes}
- Red flags found: {list}
- Estimated reduction: {percentage}

### Skills Audit
| Skill | Lines | Name | Description | References | Status |
|-------|-------|------|-------------|------------|--------|
| {name} | {n} | {ok/issue} | {ok/issue} | {ok/missing} | {overall} |

### Recommended Actions (priority order)
1. {action}
```

Present the report to the user before proceeding to Phase 2.

## Phase 2: Optimize

### 2.1 CLAUDE.md optimization

1. **Identify removable content** using [content flags](references/QUALITY-STANDARDS.md#content-flags)
2. **Extract to skills** — Candidates:
   - Procedures with 5+ steps
   - Content taking 10+ lines
   - Tasks repeated 3+ times
   - Domain knowledge not needed every session
3. **Add context hints** — Link skills from relevant sections
4. **Update CLAUDE.md** — Remove migrated content, add skill references

### 2.2 Skill optimization

1. **Fix naming violations** — Rename to gerund form, ensure consistency
2. **Improve descriptions** — Add "Use when ..." clauses, trigger keywords
3. **Apply progressive disclosure** — Extract to `references/` if SKILL.md > 100 lines
4. **Add feedback loops** — Validation steps and checklists for workflow skills

See [best practices](references/BEST-PRACTICES.md) for extraction patterns and optimization examples.

## Phase 3: Sync to Kiro

```bash
# Copy shared skills (skip agent-specific ones)
for skill in .claude/skills/*/; do
  name=$(basename "$skill")
  [[ "$name" == "optimizing-agent-instructions" ]] && continue
  cp -r "$skill" ".kiro/skills/$name"
done
```

## Phase 4: Validate

```bash
wc -l CLAUDE.md  # Target: under 100 (ideally under 50)
for f in .claude/skills/*/SKILL.md; do printf "%-50s %s\n" "$f" "$(wc -l < "$f") lines"; done
```

Run through [quality standards](references/QUALITY-STANDARDS.md) checklist to confirm all issues are resolved.
