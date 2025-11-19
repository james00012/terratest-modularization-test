# Big Bang Release Plan

This document outlines the step-by-step process for releasing the modularized terratest using the "Big Bang" approach.

## Overview

The Big Bang approach releases all modules at once in a coordinated sequence. This is faster than incremental releases but requires careful execution.

## Key Insight

**The replace directives in go.mod are ONLY used by the main module (the repo itself), not by external consumers.**

When someone does `go get github.com/gruntwork-io/terratest@v0.54.0`:
- Go downloads the source code tarball
- All code is physically present (modules/logger/, modules/shell/, etc.)
- The `replace` directives are **ignored**
- External consumers access code via the root module's physical directories
- This works fine even with v0.0.0 + replace directives!

## Release Sequence

### Step 1: Merge PR #1623 (Phase 2) to Main

**What we're merging**:
- go.work file (workspace setup)
- go.mod files for all 8 pilot modules
- require statements with v0.0.0 in root go.mod
- replace directives pointing to local paths
- All code still in root module directories

**Why this is safe for external users**:
- All code physically present in root module
- Replace directives ignored by external consumers
- They access code through root module paths
- Nothing breaks!

**After merge**:
```bash
git checkout main
git merge feature/phase2-workspace-modules
git push origin main
```

### Step 2: Tag Root Module (v0.54.0)

This creates a snapshot with workspace setup but all code still in root.

```bash
git tag v0.54.0 -m "Add Go workspace setup for modularization (Phase 2)"
git push origin v0.54.0
```

**External users can use this version**:
```bash
go get github.com/gruntwork-io/terratest@v0.54.0
# Works! All code accessed through root module
```

### Step 3: Tag All Submodules (v1.0.0)

Tag all submodules at the SAME commit as v0.54.0:

```bash
git tag modules/testing/v1.0.0
git tag modules/logger/v1.0.0
git tag modules/files/v1.0.0
git tag modules/random/v1.0.0
git tag modules/retry/v1.0.0
git tag modules/shell/v1.0.0
git tag modules/terragrunt/v1.0.0
git tag internal/lib/v1.0.0

git push origin --tags
```

**Now submodules are published**! Users can start using:
```bash
go get github.com/gruntwork-io/terratest/modules/logger@v1.0.0
```

### Step 4: Create Follow-up Branch for Module Cleanup

Create a new branch to update root module to use published submodules:

```bash
git checkout -b feature/use-published-submodules
```

### Step 5: Update Submodule go.mod Files (v0.0.0 → v1.0.0)

Update all submodule go.mod files to reference v1.0.0 instead of v0.0.0:

**Before** (modules/terragrunt/go.mod):
```go
require (
	github.com/gruntwork-io/terratest/modules/shell v0.0.0
	github.com/gruntwork-io/terratest/modules/retry v0.0.0
	// ...
)

replace (
	github.com/gruntwork-io/terratest/modules/shell => ../shell
	// ...
)
```

**After**:
```go
require (
	github.com/gruntwork-io/terratest/modules/shell v1.0.0
	github.com/gruntwork-io/terratest/modules/retry v1.0.0
	// ...
)

// Remove ALL replace directives
```

Do this for all submodules that have dependencies on other submodules.

### Step 6: Remove Submodule Directories from Root

**IMPORTANT**: This is the breaking change!

```bash
# Remove all module directories
rm -rf modules/testing
rm -rf modules/logger
rm -rf modules/files
rm -rf modules/random
rm -rf modules/retry
rm -rf modules/shell
rm -rf modules/terragrunt
rm -rf internal/lib
```

### Step 7: Update Root go.mod

Update root go.mod to use published v1.0.0 versions:

**Before**:
```go
require (
	github.com/gruntwork-io/terratest/internal/lib v0.0.0
	github.com/gruntwork-io/terratest/modules/testing v0.0.0
	// ...
)

replace (
	github.com/gruntwork-io/terratest/internal/lib => ./internal/lib
	github.com/gruntwork-io/terratest/modules/testing => ./modules/testing
	// ...
)
```

**After**:
```go
require (
	github.com/gruntwork-io/terratest/internal/lib v1.0.0
	github.com/gruntwork-io/terratest/modules/testing v1.0.0
	github.com/gruntwork-io/terratest/modules/logger v1.0.0
	github.com/gruntwork-io/terratest/modules/files v1.0.0
	github.com/gruntwork-io/terratest/modules/random v1.0.0
	github.com/gruntwork-io/terratest/modules/retry v1.0.0
	github.com/gruntwork-io/terratest/modules/shell v1.0.0
)

// Remove ALL replace directives
```

### Step 8: Run go mod tidy

```bash
go mod tidy
```

This will download the published v1.0.0 submodules from GitHub.

### Step 9: Test Everything

```bash
# Build should work
go build ./...

# Test consumer simulation
cd test-external
go mod tidy
go test -v ./...
```

### Step 10: Commit and Push

```bash
git add -A
git commit -m "Use published submodule versions v1.0.0

This commit removes the local module directories and updates all
dependencies to use the published v1.0.0 versions.

Breaking change: Users must now import submodules individually if they
want to minimize dependencies.

All existing import paths still work:
- github.com/gruntwork-io/terratest/modules/logger (now from submodule)
- github.com/gruntwork-io/terratest/modules/aws (still in root)

Root module now depends on published submodules instead of local copies."

git push origin feature/use-published-submodules
```

### Step 11: Create PR and Review

Create PR for the cleanup branch, review thoroughly.

### Step 12: Merge and Tag New Root Version

After PR is merged:

```bash
git checkout main
git pull
git tag v0.55.0 -m "Use published submodule versions

Breaking change: Submodule directories removed from root.
Users must update imports to use published submodules."

git push origin v0.55.0
```

## Timeline

**Total time**: ~1-2 hours if executed carefully

1. Merge PR #1623: 5 minutes
2. Tag v0.54.0 and submodules: 5 minutes
3. Create cleanup branch: 2 minutes
4. Update all go.mod files: 15 minutes
5. Test thoroughly: 20 minutes
6. Create PR: 5 minutes
7. Review and merge: 30 minutes
8. Tag v0.55.0: 5 minutes

## Rollback Plan

If something goes wrong:

### Before Step 12 (before v0.55.0 tag):
- Delete the cleanup branch
- Users continue using v0.54.0 (all code in root)

### After Step 12 (v0.55.0 released):
- Can't delete tags (bad practice)
- Release v0.55.1 that reverts to old structure
- Or release v0.56.0 with fixes

## Testing Plan

Test on https://github.com/james00012/terratest-modularization-test first:

1. ✅ Already did Steps 1-3
2. TODO: Do Steps 4-10 on test repo
3. Validate external consumer works
4. Then apply to real repo

## User Impact

### v0.54.0 (Workspace Setup)
**Impact**: None
- All existing code works
- New workspace for contributors
- External users unaffected

### v0.55.0 (Published Submodules)
**Impact**: Users need to update

**Before**:
```go
require github.com/gruntwork-io/terratest v0.54.0
```
All modules accessed through root.

**After**:
```go
require github.com/gruntwork-io/terratest v0.55.0
```
Pilot modules (testing, logger, files, random, retry, shell, terragrunt) now come from submodules.

Other modules (aws, terraform, k8s, etc.) still in root.

**Migration**: Users don't need to change imports, just update version.

## Success Criteria

- [ ] v0.54.0 released with workspace setup
- [ ] All submodule v1.0.0 tags created
- [ ] External consumer can use submodules
- [ ] v0.55.0 released with published submodules
- [ ] Root module builds correctly
- [ ] Test-external project passes
- [ ] No ambiguous import errors
- [ ] Documentation updated

## Next Steps

1. Complete Steps 4-10 on test repository
2. Validate everything works
3. Apply same changes to real PR #1623
4. Execute release sequence on real repo
