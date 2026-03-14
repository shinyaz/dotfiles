---
name: syncing-agent-config
description: Synchronize configuration between Claude Code and Kiro IDE. Checks CLAUDE.md vs .kiro/steering/project.md and .claude/skills/ vs .kiro/skills/ for drift. Use when agent config files are updated, skills are added or modified, or when the user mentions syncing settings between coding agents.
---

Synchronize agent configuration between Claude Code and Kiro IDE.

Copy this checklist to track progress:

```
Sync Progress:
- [ ] Step 1: Detect which side changed
- [ ] Step 2: Compare project-level config
- [ ] Step 3: Compare skills
- [ ] Step 4: Generate sync report
- [ ] Step 5: Apply changes
- [ ] Step 6: Verify
```

## File Mapping

| Claude Code | Kiro | Notes |
|---|---|---|
| `CLAUDE.md` | `.kiro/steering/project.md` | Kiro version has `inclusion: always` frontmatter |
| `.claude/skills/*/SKILL.md` | `.kiro/skills/*/SKILL.md` | Identical format (agentskills.io standard) |

### Skills with path-adapted versions (not direct copy)

- `optimizing-agent-instructions` — Each side references its own config paths (CLAUDE.md vs project.md). Reference files (`references/`) are identical and can be synced directly

## Sync Workflow

1. **Detect which side changed**
   - If `CLAUDE.md` or `.claude/skills/` was modified → sync to Kiro
   - If `.kiro/steering/project.md` or `.kiro/skills/` was modified → sync to Claude Code

2. **Compare project-level config**
   ```bash
   # Strip frontmatter from Kiro steering and compare
   diff <(sed '1,/^---$/d' .kiro/steering/project.md | sed '1,/^---$/d') CLAUDE.md
   ```
   - CLAUDE.md has `# CLAUDE.md` header — strip when comparing
   - `.kiro/steering/project.md` has YAML frontmatter (`inclusion: always`) and `# dotfiles Repository Conventions` header — strip when comparing
   - All other sections (Zsh File Usage, Coding Conventions, Internationalization) must match

3. **Compare skills**
   ```bash
   # List skills in each directory
   diff <(ls .claude/skills/ | sort) <(ls .kiro/skills/ | sort)
   ```
   - For each shared skill, compare SKILL.md content:
   ```bash
   diff .claude/skills/{skill-name}/SKILL.md .kiro/skills/{skill-name}/SKILL.md
   ```
   - Also compare `references/`, `scripts/`, `assets/` directories if they exist:
   ```bash
   diff -r .claude/skills/{skill-name}/references/ .kiro/skills/{skill-name}/references/
   ```

4. **Generate sync report**
   ```markdown
   ## Agent Config Sync Report

   ### Project Config
   - Status: In sync / Drift detected
   - Differences: (list if any)

   ### Skills
   - In sync: skill-a, skill-b
   - Drift detected: skill-c (description differs)
   - Missing in Kiro: skill-d
   - Missing in Claude Code: skill-e

   ### Recommended Actions
   1. (specific action)
   ```

5. **Apply changes**
   - Copy updated content to the target side
   - For CLAUDE.md → `.kiro/steering/project.md`: Add frontmatter, adjust header
   - For `.kiro/steering/project.md` → CLAUDE.md: Remove frontmatter, adjust header
   - For skills: Direct copy (format is identical)

6. **Verify**
   - Re-run comparison to confirm sync
   - For `optimizing-agent-instructions`: compare reference files only (SKILL.md differs by design)
