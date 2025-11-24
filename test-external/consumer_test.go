package testexternal

import (
	"testing"

	"github.com/james00012/terratest-modularization-test/modules/collections"
	dns_helper "github.com/james00012/terratest-modularization-test/modules/dns-helper"
	"github.com/james00012/terratest-modularization-test/modules/environment"
	"github.com/james00012/terratest-modularization-test/modules/git"
	http_helper "github.com/james00012/terratest-modularization-test/modules/http-helper"
	"github.com/james00012/terratest-modularization-test/modules/logger"
	"github.com/james00012/terratest-modularization-test/modules/oci"
	"github.com/james00012/terratest-modularization-test/modules/ssh"
	"github.com/james00012/terratest-modularization-test/modules/terragrunt"
	test_structure "github.com/james00012/terratest-modularization-test/modules/testing"
	"github.com/stretchr/testify/assert"
)

// TestConsumerSimulation validates that external consumers can import and use
// Terratest modules without ambiguous import errors. This test imports a
// representative mix of modules across different dependency tiers.
func TestConsumerSimulation(t *testing.T) {
	t.Parallel()

	// Test tier 0: modules/testing and modules/collections
	_ = test_structure.TestingT(t)
	result := collections.ListContains([]string{"foo", "bar"}, "foo")
	assert.True(t, result)

	// Test tier 1: modules/logger, modules/environment, modules/git
	log := logger.Default
	assert.NotNil(t, log)
	_ = environment.GetFirstNonEmptyEnvVarOrEmptyString(t, []string{"PATH"})
	_ = git.GetCurrentBranchName

	// Test tier 2: modules/oci
	_ = oci.GetRootCompartmentID

	// Test tier 3: modules/terragrunt, modules/http-helper, modules/dns-helper, modules/ssh
	options := &terragrunt.Options{
		TerragruntDir: "/path/to/terragrunt",
	}
	assert.NotNil(t, options)
	_ = http_helper.HttpGet
	_ = dns_helper.DNSLookupAuthoritative
	_ = ssh.CheckSshCommand
}
