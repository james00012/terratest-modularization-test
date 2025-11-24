package modularization_test

import (
	"os/exec"
	"path/filepath"
	"testing"
)

// TestAllModulesBuild verifies that each module can be built independently.
// This ensures each module has proper dependencies declared in its go.mod.
func TestAllModulesBuild(t *testing.T) {
	modules := []string{
		"internal/lib",
		"modules/aws",
		"modules/azure",
		"modules/collections",
		"modules/database",
		"modules/dns-helper",
		"modules/docker",
		"modules/environment",
		"modules/files",
		"modules/gcp",
		"modules/git",
		"modules/helm",
		"modules/http-helper",
		"modules/k8s",
		"modules/logger",
		"modules/oci",
		"modules/opa",
		"modules/packer",
		"modules/random",
		"modules/retry",
		"modules/shell",
		"modules/slack",
		"modules/ssh",
		"modules/terraform",
		"modules/terragrunt",
		"modules/test-structure",
		"modules/testing",
		"modules/version-checker",
	}

	// Get repository root (assuming test is in test/modularization)
	repoRoot, err := filepath.Abs("../..")
	if err != nil {
		t.Fatalf("Failed to get repo root: %v", err)
	}

	for _, module := range modules {
		t.Run(module, func(t *testing.T) {
			modulePath := filepath.Join(repoRoot, module)
			
			// Run go build
			cmd := exec.Command("go", "build", "./...")
			cmd.Dir = modulePath
			output, err := cmd.CombinedOutput()
			
			if err != nil {
				t.Errorf("Failed to build %s: %v\nOutput: %s", module, err, output)
			} else {
				t.Logf("✓ %s builds successfully", module)
			}
		})
	}
}

// TestWorkspaceBuild verifies that modules can be built using the workspace.
// With Strategy B (no root go.mod), we build specific modules from workspace context.
func TestWorkspaceBuild(t *testing.T) {
	// Get repository root
	repoRoot, err := filepath.Abs("../..")
	if err != nil {
		t.Fatalf("Failed to get repo root: %v", err)
	}

	// Build several representative modules from workspace
	modulesToBuild := []string{
		"./modules/collections",
		"./modules/ssh",
		"./modules/terraform",
		"./internal/lib",
	}

	for _, module := range modulesToBuild {
		cmd := exec.Command("go", "build", module)
		cmd.Dir = repoRoot
		output, err := cmd.CombinedOutput()

		if err != nil {
			t.Fatalf("Failed to build %s from workspace: %v\nOutput: %s", module, err, output)
		}
	}

	t.Log("✓ Modules build successfully using workspace")
}
