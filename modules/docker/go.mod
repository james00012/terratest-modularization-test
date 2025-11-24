module github.com/james00012/terratest-modularization-test/modules/docker

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/collections v0.1.0
	github.com/james00012/terratest-modularization-test/modules/git v0.1.0
	github.com/james00012/terratest-modularization-test/modules/http-helper v0.1.0
	github.com/james00012/terratest-modularization-test/modules/logger v0.1.0
	github.com/james00012/terratest-modularization-test/modules/random v0.1.0
	github.com/james00012/terratest-modularization-test/modules/shell v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
)

replace (
	github.com/james00012/terratest-modularization-test/modules/collections => ../collections
	github.com/james00012/terratest-modularization-test/modules/git => ../git
	github.com/james00012/terratest-modularization-test/modules/http-helper => ../http-helper
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/random => ../random
	github.com/james00012/terratest-modularization-test/modules/shell => ../shell
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
