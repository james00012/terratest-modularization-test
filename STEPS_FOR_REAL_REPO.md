# Steps to Execute Big Bang Modularization on Real Terratest Repository

## Test Repository

We've validated the entire process on: https://github.com/james00012/terratest-modularization-test

- **Main branch**: Has Phase 2 merged (workspace + all code)
- **Tags created**: All submodule v1.0.0 tags exist
- **Cleanup branch**: `test-repo-cleanup` shows the final state after removing directories

## Steps for gruntwork-io/terratest

### Prerequisites

- [ ] PR #1623 is reviewed and approved
- [ ] All stakeholders agree to Big Bang approach
- [ ] Communication plan ready for users about the change

### Step 1: Merge PR #1623 to Main

**What**: Merge the Phase 2 workspace setup

**Command**:
```bash
# On GitHub, merge PR #1623
# OR via command line:
git checkout main
git pull
git merge --no-ff feature/phase2-workspace-modules
git push origin main
```

**State after this step**:
- ✅ go.work file exists
- ✅ All submodule go.mod files exist
- ✅ All code still in root module directories
- ✅ Root go.mod has v0.0.0 + replace directives
- ✅ External users can use this version (replace directives ignored)

**Duration**: 5 minutes

### Step 2: Tag Submodules v1.0.0

**What**: Create all submodule tags at the current main commit

**Commands**:
```bash
git checkout main
git pull

# Tag all submodules
git tag modules/testing/v1.0.0
git tag modules/logger/v1.0.0
git tag modules/files/v1.0.0
git tag modules/random/v1.0.0
git tag modules/retry/v1.0.0
git tag modules/shell/v1.0.0
git tag modules/terragrunt/v1.0.0
git tag internal/lib/v1.0.0

# Push tags
git push origin --tags
```

**State after this step**:
- ✅ Submodules v1.0.0 are published and available
- ✅ Users can start importing: `github.com/gruntwork-io/terratest/modules/logger@v1.0.0`
- ✅ Code exists in BOTH root module AND as separate submodules

**Duration**: 5 minutes

**Wait time**: ~5 minutes for Go proxy to pick up tags

### Step 3: Create Cleanup Branch

**What**: Create branch to update dependencies and remove directories

**Commands**:
```bash
git checkout main
git pull
git checkout -b feature/use-published-submodules
```

**Duration**: 1 minute

### Step 4: Update Submodule go.mod Files

**What**: Change v0.0.0 → v1.0.0 and remove replace directives

**Files to update**:

#### modules/terragrunt/go.mod
```bash
# Change from:
require (
	github.com/gruntwork-io/terratest/internal/lib v0.0.0
	github.com/gruntwork-io/terratest/modules/files v0.0.0
	...
)
replace (
	github.com/gruntwork-io/terratest/internal/lib => ../../internal/lib
	...
)

# To:
require (
	github.com/gruntwork-io/terratest/internal/lib v1.0.0
	github.com/gruntwork-io/terratest/modules/files v1.0.0
	...
)
# (remove all replace directives)
```

#### modules/shell/go.mod
```bash
# Change v0.0.0 → v1.0.0, remove replace directives
```

#### modules/retry/go.mod
```bash
# Change v0.0.0 → v1.0.0, remove replace directives
```

#### modules/logger/go.mod
```bash
# Change v0.0.0 → v1.0.0, remove replace directives
```

**Note**: modules/files, modules/random, modules/testing don't have terratest dependencies, no changes needed

**Duration**: 10 minutes

### Step 5: Remove Submodule Directories

**What**: Delete all module directories from root

**Commands**:
```bash
rm -rf modules/testing
rm -rf modules/logger
rm -rf modules/files
rm -rf modules/random
rm -rf modules/retry
rm -rf modules/shell
rm -rf modules/terragrunt
rm -rf internal/lib
```

**Duration**: 1 minute

### Step 6: Update Root go.mod

**What**: Change v0.0.0 → v1.0.0 and remove replace directives

**Edit go.mod**:
```bash
# Change from:
require (
	github.com/gruntwork-io/terratest/internal/lib v0.0.0
	github.com/gruntwork-io/terratest/modules/testing v0.0.0
	...
)
replace (
	github.com/gruntwork-io/terratest/internal/lib => ./internal/lib
	github.com/gruntwork-io/terratest/modules/testing => ./modules/testing
	...
)

# To:
require (
	github.com/gruntwork-io/terratest/internal/lib v1.0.0
	github.com/gruntwork-io/terratest/modules/testing v1.0.0
	github.com/gruntwork-io/terratest/modules/logger v1.0.0
	github.com/gruntwork-io/terratest/modules/files v1.0.0
	github.com/gruntwork-io/terratest/modules/random v1.0.0
	github.com/gruntwork-io/terratest/modules/retry v1.0.0
	github.com/gruntwork-io/terratest/modules/shell v1.0.0
)
# (remove all replace directives)
```

**Duration**: 5 minutes

### Step 7: Update test-external/go.mod

**What**: Change v0.0.0 → v1.0.0, remove replace directives

**Edit test-external/go.mod**:
```bash
# Change from:
require (
	github.com/gruntwork-io/terratest/modules/logger v0.0.0
	...
)
replace (
	github.com/gruntwork-io/terratest/modules/logger => ../modules/logger
	...
)

# To:
require (
	github.com/gruntwork-io/terratest/modules/logger v1.0.0
	github.com/gruntwork-io/terratest/modules/terragrunt v1.0.0
	github.com/gruntwork-io/terratest/modules/testing v1.0.0
	...
)
# (remove all replace directives)
```

**Duration**: 3 minutes

### Step 8: Run go mod tidy

**What**: Download published v1.0.0 modules

**Commands**:
```bash
go mod tidy
cd test-external && go mod tidy && cd ..
```

**Expected output**: Should download all v1.0.0 modules from GitHub

**Duration**: 2 minutes

### Step 9: Build and Test

**What**: Verify everything works

**Commands**:
```bash
# Build root module
go build ./...

# Test consumer simulation
cd test-external
go test -v ./...
cd ..

# Run a few critical tests
go test ./modules/aws/... -v
go test ./modules/terraform/... -v
```

**Duration**: 10-15 minutes

### Step 10: Commit and Push

**What**: Create commit for cleanup

**Commands**:
```bash
git add -A
git commit -m "Use published submodule versions v1.0.0

This commit removes the local module directories and updates all
dependencies to use the published v1.0.0 versions.

Breaking change: Submodule directories removed from root.
Users importing submodules will now get them as separate modules.

Pilot modules now published independently:
- github.com/gruntwork-io/terratest/modules/testing@v1.0.0
- github.com/gruntwork-io/terratest/modules/logger@v1.0.0
- github.com/gruntwork-io/terratest/modules/files@v1.0.0
- github.com/gruntwork-io/terratest/modules/random@v1.0.0
- github.com/gruntwork-io/terratest/modules/retry@v1.0.0
- github.com/gruntwork-io/terratest/modules/shell@v1.0.0
- github.com/gruntwork-io/terratest/modules/terragrunt@v1.0.0
- github.com/gruntwork-io/terratest/internal/lib@v1.0.0

All other modules (aws, terraform, k8s, etc.) remain in root module.

Users can update with: go get github.com/gruntwork-io/terratest@v0.54.0"

git push origin feature/use-published-submodules
```

**Duration**: 2 minutes

### Step 11: Create PR

**What**: Create PR for the cleanup

**On GitHub**:
1. Create PR from `feature/use-published-submodules` to `main`
2. Title: "Use published submodule versions v1.0.0"
3. Add description explaining the changes
4. Link to modularization RFC
5. Request reviews

**Duration**: 5 minutes

### Step 12: Merge and Tag v0.54.0

**What**: Merge PR and create root module release

**Commands**:
```bash
# After PR is approved and merged
git checkout main
git pull

git tag v0.54.0 -m "Release v0.54.0 - Modularized pilot modules

Breaking changes:
- Pilot modules (testing, logger, files, random, retry, shell, terragrunt, internal/lib)
  are now separate Go modules
- Users importing these modules will get them as v1.0.0 submodules
- All other modules remain in root

Migration:
Users just need to update: go get github.com/gruntwork-io/terratest@v0.54.0
Import paths remain the same."

git push origin v0.54.0
```

**Duration**: 5 minutes

## Total Timeline

| Step | Duration | Waiting |
|------|----------|---------|
| 1. Merge PR #1623 | 5 min | - |
| 2. Tag submodules | 5 min | 5 min (proxy) |
| 3. Create branch | 1 min | - |
| 4. Update submodule go.mods | 10 min | - |
| 5. Remove directories | 1 min | - |
| 6. Update root go.mod | 5 min | - |
| 7. Update test-external | 3 min | - |
| 8. Run go mod tidy | 2 min | - |
| 9. Build and test | 15 min | - |
| 10. Commit and push | 2 min | - |
| 11. Create PR | 5 min | varies (review) |
| 12. Merge and tag | 5 min | - |
| **Total** | **~1 hour** | **+ review time** |

## Rollback Plan

### Before Step 12 (before v0.54.0 tag)

**If something goes wrong**:
1. Delete the cleanup branch
2. Users continue using latest (Phase 2 state)
3. All code still in root, nothing broken

### After Step 12 (v0.54.0 released)

**If critical issues found**:
1. Cannot delete tags (bad practice)
2. Options:
   - Release v0.54.1 with fixes
   - Release v0.55.0 that reverts to monolithic structure
   - Document workarounds for users

## User Communication

### Before Release

**Announce**:
- Blog post explaining modularization
- Migration guide
- Timeline for release
- What changes for users

### During Release

**Post in**:
- GitHub Discussions
- Slack/Discord
- Twitter/social media

**Message**:
> "We're releasing v0.54.0 with modularized pilot modules.
> Users can now import lightweight submodules for testing, logger, etc.
> Migration is simple: `go get github.com/gruntwork-io/terratest@v0.54.0`
> Import paths remain the same!"

### After Release

**Monitor for**:
- GitHub issues
- User questions
- Build failures
- Unexpected errors

**Be ready to**:
- Answer questions quickly
- Release hotfix if needed
- Update documentation

## Success Criteria

- [ ] v0.54.0 released successfully
- [ ] All submodule v1.0.0 tags exist and are accessible
- [ ] External users can use both root module and submodules
- [ ] No ambiguous import errors
- [ ] CI builds pass
- [ ] test-external simulation passes
- [ ] Documentation updated
- [ ] No critical bugs reported within 48 hours

## Reference

- **Test repository**: https://github.com/james00012/terratest-modularization-test
- **Main branch**: Phase 2 state (workspace + all code)
- **Cleanup branch**: `test-repo-cleanup` (final state)
- **Real PR**: #1623

## Files Changed

### Modified
- `go.mod` - Updated to v1.0.0 dependencies
- `go.work` - (no changes needed)
- `test-external/go.mod` - Updated to v1.0.0
- All submodule `go.mod` files - Updated to v1.0.0

### Deleted
- `modules/testing/` - All files
- `modules/logger/` - All files
- `modules/files/` - All files
- `modules/random/` - All files
- `modules/retry/` - All files
- `modules/shell/` - All files
- `modules/terragrunt/` - All files
- `internal/lib/` - All files

**Total**: ~240 files deleted, ~530 lines changed in go.mod files

## Next Steps After v0.54.0

1. Monitor for issues
2. Plan remaining modules (Phase 4)
3. Repeat process for modules/terraform, modules/aws, etc.
4. Eventually complete full modularization
