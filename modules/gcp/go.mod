module github.com/james00012/terratest-modularization-test/modules/gcp

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/collections v0.1.0
	github.com/james00012/terratest-modularization-test/modules/environment v0.1.0
	github.com/james00012/terratest-modularization-test/modules/logger v0.1.0
	github.com/james00012/terratest-modularization-test/modules/random v0.1.0
	github.com/james00012/terratest-modularization-test/modules/retry v0.1.0
	github.com/james00012/terratest-modularization-test/modules/ssh v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
)

replace (
	github.com/james00012/terratest-modularization-test/modules/collections => ../collections
	github.com/james00012/terratest-modularization-test/modules/environment => ../environment
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/random => ../random
	github.com/james00012/terratest-modularization-test/modules/retry => ../retry
	github.com/james00012/terratest-modularization-test/modules/ssh => ../ssh
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
