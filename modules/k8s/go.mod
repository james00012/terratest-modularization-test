module github.com/james00012/terratest-modularization-test/modules/k8s

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/aws v0.1.0
	github.com/james00012/terratest-modularization-test/modules/environment v0.1.0
	github.com/james00012/terratest-modularization-test/modules/files v0.1.0
	github.com/james00012/terratest-modularization-test/modules/http-helper v0.1.0
	github.com/james00012/terratest-modularization-test/modules/logger v0.1.0
	github.com/james00012/terratest-modularization-test/modules/random v0.1.0
	github.com/james00012/terratest-modularization-test/modules/retry v0.1.0
	github.com/james00012/terratest-modularization-test/modules/shell v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
)

replace (
	github.com/james00012/terratest-modularization-test/modules/aws => ../aws
	github.com/james00012/terratest-modularization-test/modules/environment => ../environment
	github.com/james00012/terratest-modularization-test/modules/files => ../files
	github.com/james00012/terratest-modularization-test/modules/http-helper => ../http-helper
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/random => ../random
	github.com/james00012/terratest-modularization-test/modules/retry => ../retry
	github.com/james00012/terratest-modularization-test/modules/shell => ../shell
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
