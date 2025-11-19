# Centralizing External Dependencies Across Terratest Modules

## Problem Statement

When modularizing Terratest, each submodule has its own `go.mod` file with its own external dependencies. This can lead to:

1. **Version Inconsistency**: Different modules using different versions of the same dependency
   - Example: `modules/logger` uses `stretchr/testify v1.10.0`
   - Example: `modules/terragrunt` uses `stretchr/testify v1.11.1`

2. **Maintenance Burden**: Need to update dependencies in multiple go.mod files

3. **Potential Conflicts**: Users importing multiple modules might get unexpected version resolution

## Current Dependency State

### External Dependencies Across Modules

**modules/logger/go.mod**
```go
require (
	github.com/stretchr/testify v1.10.0
)
```

**modules/shell/go.mod**
```go
require (
	github.com/stretchr/testify v1.11.1
)
```

**modules/terragrunt/go.mod**
```go
require (
	github.com/stretchr/testify v1.11.1
	github.com/mattn/go-zglob v0.0.2-0.20190814121620-e3c945676326
	golang.org/x/net v0.47.0
)
```

**Root go.mod**
```go
require (
	github.com/stretchr/testify v1.10.0
	// ... and many others
)
```

---

## Solution: Go Workspace + go work sync

Go 1.18+ provides built-in tooling for centralizing dependency versions across workspace modules.

### Strategy Overview

1. **Root go.mod as Source of Truth**: Define all external dependency versions in root go.mod
2. **Use `go work sync`**: Synchronize versions from workspace to all submodule go.mod files
3. **CI/CD Validation**: Ensure all modules use consistent versions

---

## Implementation Approach

### Option 1: Minimal Version Selection (MVS) - Go's Default

**How it works:**
- When multiple modules require different versions of a dependency, Go's MVS picks the **highest required version**
- This happens automatically when using workspaces

**Example:**
```
modules/logger requires testify v1.10.0
modules/shell requires testify v1.11.1
→ Go uses v1.11.1 for entire workspace
```

**Pros:**
- ✅ Automatic - no manual intervention needed
- ✅ Go's standard behavior
- ✅ Safe - always picks compatible version

**Cons:**
- ⚠️ Version can drift if not monitored
- ⚠️ Still have different versions written in go.mod files (confusing)

**Status:** This is what happens by default with our current setup

---

### Option 2: go work sync (Recommended)

**How it works:**
```bash
# 1. Update root go.mod to desired versions
go get github.com/stretchr/testify@v1.11.1

# 2. Sync versions to all workspace modules
go work sync
```

The `go work sync` command:
- Reads the workspace build list (from root + all workspace modules)
- Updates each workspace module's go.mod to match the workspace versions
- Ensures all modules declare the same version for shared dependencies

**Example workflow:**
```bash
# In root directory with go.work
cd /path/to/terratest

# Update a dependency in root
go get github.com/stretchr/testify@v1.11.1

# Sync to all workspace modules
go work sync

# Result: All modules now have testify v1.11.1 in their go.mod
```

**Pros:**
- ✅ Explicit version alignment
- ✅ Easy to verify (grep all go.mod files)
- ✅ Single command to synchronize
- ✅ Works for contributors using workspace mode

**Cons:**
- ⚠️ Manual step (can be automated in CI)
- ⚠️ Doesn't help external users (they don't use go.work)

**Status:** **RECOMMENDED** for this project

---

### Option 3: Centralized Dependency Management Tool

**Tools available:**
- [dependabot](https://github.com/dependabot) - GitHub's automated dependency updates
- [renovate](https://github.com/renovatebot/renovate) - Multi-platform dependency automation
- Custom scripts to sync versions

**How it works:**
1. Tool scans all go.mod files in repository
2. Identifies version mismatches
3. Creates PRs to align versions

**Pros:**
- ✅ Fully automated
- ✅ Works across all files
- ✅ Can configure policies

**Cons:**
- ⚠️ Requires external tooling
- ⚠️ More complex setup
- ⚠️ Still need `go work sync` for local development

**Status:** Can be added on top of Option 2

---

## Recommended Implementation

### Step 1: Align Current Versions

Before releasing the modularization, ensure all modules use consistent external dependency versions:

```bash
# In terratest root with go.work
cd /Users/jameskwon/code/gruntwork/terratest-modularization

# Check current state
grep -r "stretchr/testify" */go.mod

# Update root to highest version
go get github.com/stretchr/testify@v1.11.1

# Sync to all workspace modules
go work sync

# Verify alignment
grep -r "stretchr/testify" */go.mod
```

Expected result: All go.mod files show `v1.11.1`

### Step 2: Update Single Mega-Commit

Modify the single mega-commit to include aligned dependency versions:

1. Check out the commit
2. Run `go work sync`
3. Amend the commit with updated go.mod files
4. Force push updated tags

### Step 3: Document the Process

Add to `CONTRIBUTING.md`:

```markdown
## Updating Dependencies

When updating external dependencies, use `go work sync` to keep versions aligned:

1. Update the dependency in root go.mod:
   ```bash
   go get github.com/stretchr/testify@v1.12.0
   ```

2. Sync to all workspace modules:
   ```bash
   go work sync
   ```

3. Verify all modules updated:
   ```bash
   grep -r "stretchr/testify" */go.mod
   ```

4. Commit all changed go.mod files together
```

### Step 4: Add CI Validation

Create a GitHub Action to verify version alignment:

```yaml
name: Verify Dependency Alignment

on: [pull_request]

jobs:
  check-deps:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - uses: actions/setup-go@v4
        with:
          go-version: '1.24'

      - name: Check dependency alignment
        run: |
          # Run go work sync in dry-run mode
          go work sync

          # Check if any go.mod files changed
          if ! git diff --exit-code '**/go.mod'; then
            echo "❌ Dependencies are not aligned!"
            echo "Run 'go work sync' to align versions"
            exit 1
          fi

          echo "✅ All dependencies aligned"
```

---

## External User Perspective

### Important Note: Workspaces Don't Affect External Users

When external users import terratest modules, they **do not use go.work**. Go's MVS will handle version resolution:

**User imports:**
```go
import (
    "github.com/gruntwork-io/terratest/modules/logger"   // requires testify v1.10.0
    "github.com/gruntwork-io/terratest/modules/shell"    // requires testify v1.11.1
)
```

**Go's resolution:**
- MVS picks v1.11.1 (highest version)
- User gets consistent version across all terratest modules

**Why this matters:**
- Even if we align versions internally, external users benefit from MVS
- Aligning versions reduces confusion and makes testing more predictable
- Ensures what we test locally matches what users experience

---

## Handling the Root Module Dependency

### Current Situation

Root go.mod requires:
```go
require (
	github.com/gruntwork-io/terratest/modules/logger v1.0.0
	github.com/gruntwork-io/terratest/modules/shell v1.0.0
	// ...
	github.com/stretchr/testify v1.10.0  // ← Direct dependency
)
```

Each submodule also requires testify (indirect via root).

### Question: Should Root Depend on External Libraries?

**Option A: Root has direct external dependencies**
- Root declares: `testify v1.11.1`
- Submodules declare: `testify v1.11.1`
- Result: Explicit everywhere

**Option B: Root only depends on submodules**
- Root declares: Only submodule dependencies
- Submodules declare: `testify v1.11.1`
- Result: Root gets testify transitively

**Recommendation: Option A (Explicit)**
- More maintainable
- Clearer dependency graph
- Easier to update (one source of truth + sync)

---

## Common External Dependencies to Align

Based on current go.mod files, these external dependencies appear in multiple modules:

1. **github.com/stretchr/testify** - Used by almost all modules
2. **github.com/davecgh/go-spew** - Transitive dep from testify
3. **github.com/pmezard/go-difflib** - Transitive dep from testify
4. **gopkg.in/yaml.v3** - Transitive dep from testify
5. **golang.org/x/net** - Used by several modules
6. **github.com/mattn/go-zglob** - Used by terragrunt

All should be aligned to same versions across modules.

---

## Action Plan for Test Repository

Let's update the test repository to demonstrate aligned dependencies:

```bash
# 1. Checkout single-mega-commit branch
git checkout single-mega-commit

# 2. Ensure all submodule go.mod files exist (recreate if needed)
# They were deleted in the mega-commit, so we need the state BEFORE deletion

# 3. Update root to desired versions
go get github.com/stretchr/testify@v1.11.1

# 4. Sync to all modules
go work sync

# 5. Verify
grep -r "stretchr/testify" */go.mod

# 6. Commit
git add -A
git commit --amend --no-edit

# 7. Re-tag
git tag -f modules/logger/v1.0.0
# ... (all other tags)

# 8. Force push
git push test-repo single-mega-commit --force-with-lease
git push test-repo --tags --force
```

---

## Summary

### Best Approach: Go Workspace + go work sync

1. **For Contributors (using workspace)**:
   - `go work sync` keeps all module versions aligned
   - Single source of truth: root go.mod

2. **For External Users**:
   - Go's MVS automatically picks consistent versions
   - Works even if we have minor misalignments (but we should avoid them)

3. **For Maintenance**:
   - Update root go.mod
   - Run `go work sync`
   - CI validates alignment

4. **For This Project**:
   - Add `go work sync` to contributor docs
   - Add CI check to verify alignment
   - Update single-mega-commit to have aligned versions from the start

### Key Command

```bash
go work sync
```

This single command solves the centralization problem for workspace development.

---

## Questions to Consider

1. **Should we run `go work sync` now on the test repo before finalizing?**
   - Yes - ensures clean aligned state from v1.0.0

2. **Should we add CI validation for version alignment?**
   - Yes - prevents drift over time

3. **Should we document this in CONTRIBUTING.md?**
   - Yes - helps future contributors understand the workflow

4. **What about dependencies unique to one module?**
   - Keep them - only shared dependencies need alignment
   - Example: `mattn/go-zglob` only needed by terragrunt - that's fine

---

**Next Step**: Update the single-mega-commit on test repo to include aligned dependency versions via `go work sync`.
