# Optimizing Agent Instructions — Patterns and Examples

For quality standards (naming, descriptions, progressive disclosure, CLAUDE.md criteria), see [QUALITY-STANDARDS.md](QUALITY-STANDARDS.md).

## Optimization Patterns

### Transform verbose instructions

**Before:**
```markdown
When creating new components, always use TypeScript
interfaces for props, place them above the component,
export the component as default if it's the main export...
```

**After:**
```markdown
- TypeScript interfaces for props
- Default export for main components
```

### Extract procedures to skills

**Before (in CLAUDE.md):**
```markdown
## How to add a new API endpoint
1. Create route file in app/api/
2. Define handler function
3. Add validation
4. Update OpenAPI spec
5. Write tests
```

**After:** Create skill `/adding-api-endpoints`

### Remove inferrable content

**Remove:** "Use async/await instead of callbacks"
**Why:** Standard modern JavaScript practice the agent already knows

### Add context hints to CLAUDE.md

**Before:**
```markdown
- **Build must pass** — No warnings allowed
```

**After:**
```markdown
- **Build must pass** — No warnings allowed. Build fails → `/debugging-build`
```

## Workflow Skills Checklist

- [ ] Clear step-by-step instructions
- [ ] Copyable progress checklist for Claude to track
- [ ] Validation/feedback loop (validate → fix → repeat)
- [ ] No `git add -A` or auto-commit steps
