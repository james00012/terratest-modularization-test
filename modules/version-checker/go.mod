module github.com/james00012/terratest-modularization-test/modules/version-checker

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/shell v0.1.0
	github.com/james00012/terratest-modularization-test/modules/terraform v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
)

replace (
	github.com/james00012/terratest-modularization-test/modules/shell => ../shell
	github.com/james00012/terratest-modularization-test/modules/terraform => ../terraform
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
