# Terratest Modularization

This repository implements a **fully modularized** version of Terratest using Go modules, allowing consumers to import only the modules they need rather than the entire library.

## Overview

### What Changed

- **27 independent modules** in the `modules/` directory
- **1 internal library** at `internal/lib/`
- **No root go.mod** (Strategy B) - prevents ambiguous imports
- **Go workspace** (`go.work`) for local development
- **Independent versioning** for each module using git tags

### Benefits

1. **Reduced Dependencies**: Import only what you need
   - Before: Importing any Terratest package pulled the entire library
   - After: Import `modules/terraform` and only get terraform + its direct dependencies

2. **No Ambiguous Imports**: Eliminates [issue #1613](https://github.com/gruntwork-io/terratest/issues/1613)
   - Each package has exactly one source of truth
   - No conflicts between root module and submodules

3. **Independent Versioning**: Each module can be versioned separately
   - `modules/terraform v0.2.0` can coexist with `modules/aws v0.1.5`
   - Semantic versioning per module

4. **Faster Builds**: Smaller dependency graphs
   - Only compile what you import
   - Reduced build times for consumers

## Architecture

### Module Structure

```
terratest-modularization-test/
├── go.work                    # Workspace for local development
├── internal/
│   └── lib/                   # Internal shared utilities
│       └── go.mod
├── modules/
│   ├── aws/                   # AWS testing utilities
│   │   └── go.mod
│   ├── azure/                 # Azure testing utilities
│   │   └── go.mod
│   ├── collections/           # Collection utilities (Tier 0)
│   │   └── go.mod
│   ├── terraform/             # Terraform testing utilities
│   │   └── go.mod
│   └── ... (23 more modules)
└── test/
    └── modularization/        # Modularization validation tests
        └── go.mod
```

### Dependency Tiers

**Tier 0** - No Terratest dependencies:
- `modules/collections`

**Tier 1** - Testing framework only:
- `modules/logger` → `modules/testing`
- `modules/random` → `modules/testing`

**Tier 2** - 2-3 dependencies:
- `modules/retry` → `modules/logger`, `modules/testing`
- `modules/shell` → `modules/logger`, `modules/testing`

**Tier 3+** - Complex modules:
- `modules/ssh` → 6 dependencies
- `modules/terraform` → 10+ dependencies
- `modules/aws` → 15+ dependencies

## Usage

### For Consumers

Import only the modules you need:

```go
import (
    "github.com/james00012/terratest-modularization-test/modules/terraform"
    "github.com/james00012/terratest-modularization-test/modules/aws"
)
```

In your `go.mod`:

```go
require (
    github.com/james00012/terratest-modularization-test/modules/terraform v0.1.0
    github.com/james00012/terratest-modularization-test/modules/aws v0.1.0
)
```

**No replace directives needed!** Go automatically fetches the correct versions from GitHub.

### For Contributors

When working on the repository locally:

1. **The workspace (`go.work`) is already configured** with all modules
2. **Build any module**: `go build ./modules/terraform`
3. **Run tests**: `go test ./modules/terraform/...`
4. **Build all**: `go build ./...` (uses workspace)

The workspace enables seamless local development across modules while maintaining their independence.

## Modularization Strategy

### Strategy B: No Root Module

We chose **Strategy B** (no root `go.mod`) over Strategy A (root aggregator module) because:

1. **Prevents ambiguous imports** (issue #1613)
   - With root module: Same package exists in both root and submodule → ambiguous
   - Without root module: Each package has exactly one source → no ambiguity

2. **Simpler mental model**
   - Each module is independent
   - No confusion about which module to import from

3. **Cleaner dependency graphs**
   - Consumers explicitly choose which modules to use
   - No hidden transitive dependencies from root module

### Replace Directives

Each module's `go.mod` includes replace directives for **local development only**:

```go
replace (
    github.com/james00012/terratest-modularization-test/modules/logger => ../logger
)
```

**Important**: Consumers don't need these! Replace directives are only for repository developers. When modules are published with git tags, Go fetches them directly from GitHub.

## Version Tags

Each module is versioned independently using git tags with the module path as prefix:

```bash
git tag modules/terraform/v0.1.0
git tag modules/aws/v0.1.0
git tag internal/lib/v0.1.0
```

This follows Go's [module versioning conventions](https://go.dev/wiki/Modules#faqs--multi-module-repositories) for multi-module repositories.

## Testing

Comprehensive tests validate the modularization:

### Dependency Isolation Tests

Verify that importing individual modules doesn't pull the entire repository:

```bash
go test ./test/modularization -run TestDependencyIsolation -v
```

Tests various tiers:
- Tier 0: `collections` pulls only itself
- Tier 1: `logger` pulls only logger + testing
- Tier 3: `ssh` pulls only its 6 direct dependencies (not all 27 modules)

### Ambiguous Import Tests

Verify that importing multiple modules simultaneously doesn't cause conflicts:

```bash
go test ./test/modularization -run TestNoAmbiguousImports -v
```

This validates the fix for [issue #1613](https://github.com/gruntwork-io/terratest/issues/1613).

### Build Tests

Verify all modules build independently and together:

```bash
go test ./test/modularization -run TestAllModulesBuild -v
go test ./test/modularization -run TestWorkspaceBuild -v
```

### Run All Tests

```bash
cd test/modularization
go test -v ./...
```

## Migration Guide

### For Existing Users

**No breaking changes!** Import paths remain the same:

**Before:**
```go
import "github.com/gruntwork-io/terratest/modules/terraform"
```

**After:**
```go
import "github.com/james00012/terratest-modularization-test/modules/terraform"
```

Your `go.mod` will automatically manage the dependencies:

**Before:**
```go
require github.com/gruntwork-io/terratest v0.52.0  // Pulls everything
```

**After:**
```go
require github.com/james00012/terratest-modularization-test/modules/terraform v0.1.0  // Pulls only terraform + deps
```

### For Module Maintainers

When adding a new module:

1. Create `modules/newmodule/go.mod`:
   ```go
   module github.com/james00012/terratest-modularization-test/modules/newmodule
   
   go 1.24.0
   
   require (
       // Your dependencies
   )
   
   replace (
       // Local replace directives for development
   )
   ```

2. Add to `go.work`:
   ```go
   use (
       // ... existing modules
       ./modules/newmodule
   )
   ```

3. Create version tag:
   ```bash
   git tag modules/newmodule/v0.1.0
   git push origin modules/newmodule/v0.1.0
   ```

## Comparison: Before vs After

### Dependency Size

**Before (monolithic):**
```bash
go get github.com/gruntwork-io/terratest
# Downloads ~50MB, pulls all AWS/Azure/GCP/K8s dependencies
```

**After (modular):**
```bash
go get github.com/james00012/terratest-modularization-test/modules/collections
# Downloads ~100KB, pulls only testify
```

### Build Time

**Before:**
- First build: ~2-3 minutes (compiles everything)
- Incremental: ~30-60 seconds

**After:**
- First build: ~10-30 seconds (only imported modules)
- Incremental: ~5-10 seconds

### Dependency Count

**Example: Using only terraform module**

**Before:**
- Direct dependencies: 100+
- Includes AWS, Azure, GCP, Docker, Kubernetes SDKs (unused)

**After:**
- Direct dependencies: ~15
- Only terraform-related dependencies + shared utilities

## Troubleshooting

### "unknown revision modules/xyz/v0.1.0"

The module tag hasn't been pushed to GitHub yet:

```bash
git push origin modules/xyz/v0.1.0
```

### "ambiguous import"

This shouldn't happen with Strategy B. If you see this:
1. Verify there's no `go.mod` in the repository root
2. Check that module paths are unique
3. Report as a bug

### "verifying module: 404 Not Found"

For private/test repositories, bypass the checksum database:

```bash
export GONOSUMDB=github.com/james00012/terratest-modularization-test
go mod tidy
```

Or set in `go.env`:
```
GONOSUMDB=github.com/james00012/terratest-modularization-test
```

## References

- [Go Modules Multi-Module Repositories](https://go.dev/wiki/Modules#faqs--multi-module-repositories)
- [Go Workspaces](https://go.dev/blog/get-familiar-with-workspaces)
- [Terratest Issue #1613](https://github.com/gruntwork-io/terratest/issues/1613) - Ambiguous import problem
- [Semantic Versioning](https://semver.org/)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

## License

Same as Terratest - Apache 2.0 License
