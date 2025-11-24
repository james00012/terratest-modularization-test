module github.com/james00012/terratest-modularization-test/modules/helm

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/files v0.1.0
	github.com/james00012/terratest-modularization-test/modules/http-helper v0.1.0
	github.com/james00012/terratest-modularization-test/modules/k8s v0.1.0
	github.com/james00012/terratest-modularization-test/modules/logger v0.1.0
	github.com/james00012/terratest-modularization-test/modules/random v0.1.0
	github.com/james00012/terratest-modularization-test/modules/shell v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
)

replace (
	github.com/james00012/terratest-modularization-test/modules/files => ../files
	github.com/james00012/terratest-modularization-test/modules/http-helper => ../http-helper
	github.com/james00012/terratest-modularization-test/modules/k8s => ../k8s
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/random => ../random
	github.com/james00012/terratest-modularization-test/modules/shell => ../shell
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
