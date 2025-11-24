package terragrunt

import (
	"testing"

	"github.com/james00012/terratest-modularization-test/modules/files"
	"github.com/stretchr/testify/require"
)

func TestApplyAllNoError(t *testing.T) {
	t.Parallel()

	testFolder, err := files.CopyTerragruntFolderToTemp("../../test/fixtures/terragrunt/terragrunt-no-error", t.Name())
	require.NoError(t, err)

	options := &Options{
		TerragruntDir:    testFolder,
		TerragruntBinary: "terragrunt",
	}

	out := ApplyAll(t, options)

	require.Contains(t, out, "Hello, World")
}
