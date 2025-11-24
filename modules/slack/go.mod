module github.com/james00012/terratest-modularization-test/modules/slack

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/environment v0.1.0
	github.com/james00012/terratest-modularization-test/modules/random v0.1.0
	github.com/james00012/terratest-modularization-test/modules/retry v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
)

replace (
	github.com/james00012/terratest-modularization-test/modules/environment => ../environment
	github.com/james00012/terratest-modularization-test/modules/random => ../random
	github.com/james00012/terratest-modularization-test/modules/retry => ../retry
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
