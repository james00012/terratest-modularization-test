# Modularization Tests

This directory contains comprehensive tests validating the Terratest modularization.

## Test Suites

### 1. Dependency Isolation Tests (`dependency_isolation_test.go`)

Verifies that importing individual modules only pulls their direct dependencies, not the entire monorepo.

**What it tests:**
- Tier 0 modules (e.g., `collections`) pull only themselves
- Tier 1 modules (e.g., `logger`) pull minimal dependencies
- Tier 3 modules (e.g., `ssh`) pull only their dependency tree, not all 27 modules

**Run:**
```bash
go test -v -run TestDependencyIsolation
```

### 2. Ambiguous Import Tests (`ambiguous_import_test.go`)

Verifies that importing multiple modules simultaneously doesn't cause ambiguous import errors.

**What it tests:**
- Multiple modules can be imported in the same project
- Shared dependencies (like `logger`, `collections`) resolve correctly
- No conflicts between modules
- Validates fix for [issue #1613](https://github.com/gruntwork-io/terratest/issues/1613)

**Run:**
```bash
go test -v -run TestNoAmbiguousImports
```

### 3. Module Build Tests (`module_build_test.go`)

Verifies that all modules build independently and together.

**What it tests:**
- Each of the 27 modules builds successfully on its own
- The workspace builds all modules together
- Dependencies are correctly declared in each module's `go.mod`

**Run:**
```bash
go test -v -run TestAllModulesBuild
go test -v -run TestWorkspaceBuild
```

## Running All Tests

```bash
# From this directory
go test -v ./...

# Or from repository root
go test -v ./test/modularization/...
```

## Test Requirements

These tests require:
- Git tags to be pushed to GitHub (or use `GONOSUMDB` for local testing)
- Network access to fetch modules from GitHub
- Go 1.24.0 or later

## Local Testing

For local testing before pushing tags, set:

```bash
export GONOSUMDB=github.com/james00012/terratest-modularization-test
go test -v ./...
```

This bypasses the Go checksum database and allows testing with unpublished modules.

## Expected Results

All tests should pass, demonstrating:
- ✓ Dependency isolation working correctly
- ✓ No ambiguous imports
- ✓ All modules build independently
- ✓ Workspace builds successfully
- ✓ Strategy B implementation complete

## Continuous Integration

These tests should be run in CI to ensure:
1. No regressions in module dependencies
2. New modules follow the same patterns
3. Ambiguous imports never reoccur
4. All modules remain buildable
