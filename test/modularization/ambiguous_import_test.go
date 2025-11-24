package modularization_test

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// TestNoAmbiguousImports verifies that importing multiple modules simultaneously
// doesn't cause ambiguous import errors. This validates that Strategy B
// (no root go.mod) successfully prevents the issue described in
// https://github.com/gruntwork-io/terratest/issues/1613
func TestNoAmbiguousImports(t *testing.T) {
	// Create temporary directory for test
	tmpDir, err := os.MkdirTemp("", "ambiguous-test-*")
	if err != nil {
		t.Fatalf("Failed to create temp dir: %v", err)
	}
	defer os.RemoveAll(tmpDir)

	// Create go.mod importing multiple modules with shared dependencies
	goMod := `module ambiguous-test

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/terraform v0.1.0
	github.com/james00012/terratest-modularization-test/modules/aws v0.1.0
	github.com/james00012/terratest-modularization-test/modules/k8s v0.1.0
	github.com/james00012/terratest-modularization-test/modules/docker v0.1.0
	github.com/james00012/terratest-modularization-test/modules/ssh v0.1.0
)
`
	if err := os.WriteFile(filepath.Join(tmpDir, "go.mod"), []byte(goMod), 0644); err != nil {
		t.Fatalf("Failed to write go.mod: %v", err)
	}

	// Create main.go that imports all these modules
	mainGo := `package main

import (
	"fmt"
	
	"github.com/james00012/terratest-modularization-test/modules/terraform"
	"github.com/james00012/terratest-modularization-test/modules/aws"
	"github.com/james00012/terratest-modularization-test/modules/k8s"
	"github.com/james00012/terratest-modularization-test/modules/docker"
	"github.com/james00012/terratest-modularization-test/modules/ssh"
	
	"github.com/james00012/terratest-modularization-test/modules/collections"
	"github.com/james00012/terratest-modularization-test/modules/logger"
)

func main() {
	_ = terraform.WorkspaceSelectOrNew
	_ = aws.NewNotFoundError
	_ = k8s.CanIDo
	_ = docker.Build
	_ = ssh.CheckSshCommand
	_ = collections.ListContains
	_ = logger.Default
	
	fmt.Println("No ambiguous imports!")
}
`
	if err := os.WriteFile(filepath.Join(tmpDir, "main.go"), []byte(mainGo), 0644); err != nil {
		t.Fatalf("Failed to write main.go: %v", err)
	}

	// Run go mod tidy
	t.Log("Running go mod tidy...")
	cmd := exec.Command("go", "mod", "tidy")
	cmd.Dir = tmpDir
	cmd.Env = append(os.Environ(), "GONOSUMDB=github.com/james00012/terratest-modularization-test")
	output, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("go mod tidy failed: %v\nOutput: %s", err, output)
	}

	// Try to build - this will fail if there are ambiguous imports
	t.Log("Running go build...")
	cmd = exec.Command("go", "build")
	cmd.Dir = tmpDir
	cmd.Env = append(os.Environ(), "GONOSUMDB=github.com/james00012/terratest-modularization-test")
	output, err = cmd.CombinedOutput()
	
	// Check for ambiguous import error
	outputStr := string(output)
	if strings.Contains(outputStr, "ambiguous import") {
		t.Fatalf("Ambiguous import error detected:\n%s", outputStr)
	}
	
	if err != nil {
		t.Fatalf("go build failed: %v\nOutput: %s", err, output)
	}

	t.Log("✓ No ambiguous imports detected")
	t.Log("✓ All modules coexist without conflicts")
	t.Log("✓ Strategy B successfully prevents issue #1613")
}
