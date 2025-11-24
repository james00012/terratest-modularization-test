module github.com/james00012/terratest-modularization-test/modules/oci

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/logger v0.1.0
	github.com/james00012/terratest-modularization-test/modules/random v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
	github.com/oracle/oci-go-sdk v24.3.0+incompatible
)

replace (
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/random => ../random
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
