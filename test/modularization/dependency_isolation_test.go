package modularization_test

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// TestDependencyIsolation verifies that importing individual modules
// only pulls their direct dependencies, not the entire monorepo.
// This prevents dependency bloat for consumers.
func TestDependencyIsolation(t *testing.T) {
	tests := []struct {
		name               string
		module             string
		maxExpectedModules int // Maximum number of terratest modules expected
		description        string
	}{
		{
			name:               "Tier0_Collections",
			module:             "github.com/james00012/terratest-modularization-test/modules/collections",
			maxExpectedModules: 1, // Only collections itself
			description:        "Collections has no terratest dependencies",
		},
		{
			name:               "Tier1_Logger",
			module:             "github.com/james00012/terratest-modularization-test/modules/logger",
			maxExpectedModules: 2, // logger + testing
			description:        "Logger only depends on testing module",
		},
		{
			name:               "Tier2_Retry",
			module:             "github.com/james00012/terratest-modularization-test/modules/retry",
			maxExpectedModules: 3, // retry + logger + testing
			description:        "Retry depends on logger and testing",
		},
		{
			name:               "Tier3_SSH",
			module:             "github.com/james00012/terratest-modularization-test/modules/ssh",
			maxExpectedModules: 7, // ssh + collections + files + logger + retry + testing + shell
			description:        "SSH has multiple dependencies but not all modules",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Create temporary directory for test
			tmpDir, err := os.MkdirTemp("", "dep-test-*")
			if err != nil {
				t.Fatalf("Failed to create temp dir: %v", err)
			}
			defer os.RemoveAll(tmpDir)

			// Create minimal go.mod
			goMod := `module dep-test

go 1.24.0

require ` + tt.module + ` v0.1.0
`
			if err := os.WriteFile(filepath.Join(tmpDir, "go.mod"), []byte(goMod), 0644); err != nil {
				t.Fatalf("Failed to write go.mod: %v", err)
			}

			// Create minimal main.go
			mainGo := `package main
func main() {}
`
			if err := os.WriteFile(filepath.Join(tmpDir, "main.go"), []byte(mainGo), 0644); err != nil {
				t.Fatalf("Failed to write main.go: %v", err)
			}

			// Run go mod download
			cmd := exec.Command("go", "mod", "download")
			cmd.Dir = tmpDir
			cmd.Env = append(os.Environ(), "GONOSUMDB=github.com/james00012/terratest-modularization-test")
			output, err := cmd.CombinedOutput()
			if err != nil {
				t.Fatalf("go mod download failed: %v\nOutput: %s", err, output)
			}

			// List all dependencies
			cmd = exec.Command("go", "list", "-m", "all")
			cmd.Dir = tmpDir
			output, err = cmd.CombinedOutput()
			if err != nil {
				t.Fatalf("go list failed: %v\nOutput: %s", err, output)
			}

			// Count terratest modules
			lines := strings.Split(string(output), "\n")
			terratestModuleCount := 0
			var terratestModules []string
			for _, line := range lines {
				if strings.Contains(line, "github.com/james00012/terratest-modularization-test/modules/") ||
					strings.Contains(line, "github.com/james00012/terratest-modularization-test/internal/") {
					terratestModuleCount++
					terratestModules = append(terratestModules, strings.Fields(line)[0])
				}
			}

			t.Logf("Module: %s", tt.module)
			t.Logf("Description: %s", tt.description)
			t.Logf("Expected max modules: %d", tt.maxExpectedModules)
			t.Logf("Actual modules: %d", terratestModuleCount)
			t.Logf("Modules pulled: %v", terratestModules)

			if terratestModuleCount > tt.maxExpectedModules {
				t.Errorf("Too many terratest modules pulled. Expected max %d, got %d.\nModules: %v",
					tt.maxExpectedModules, terratestModuleCount, terratestModules)
			}
		})
	}
}
