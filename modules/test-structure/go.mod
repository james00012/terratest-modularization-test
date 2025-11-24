module github.com/james00012/terratest-modularization-test/modules/test-structure

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/aws v0.1.0
	github.com/james00012/terratest-modularization-test/modules/collections v0.1.0
	github.com/james00012/terratest-modularization-test/modules/files v0.1.0
	github.com/james00012/terratest-modularization-test/modules/git v0.1.0
	github.com/james00012/terratest-modularization-test/modules/k8s v0.1.0
	github.com/james00012/terratest-modularization-test/modules/logger v0.1.0
	github.com/james00012/terratest-modularization-test/modules/opa v0.1.0
	github.com/james00012/terratest-modularization-test/modules/packer v0.1.0
	github.com/james00012/terratest-modularization-test/modules/ssh v0.1.0
	github.com/james00012/terratest-modularization-test/modules/terraform v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
)

replace (
	github.com/james00012/terratest-modularization-test/modules/aws => ../aws
	github.com/james00012/terratest-modularization-test/modules/collections => ../collections
	github.com/james00012/terratest-modularization-test/modules/files => ../files
	github.com/james00012/terratest-modularization-test/modules/git => ../git
	github.com/james00012/terratest-modularization-test/modules/k8s => ../k8s
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/opa => ../opa
	github.com/james00012/terratest-modularization-test/modules/packer => ../packer
	github.com/james00012/terratest-modularization-test/modules/ssh => ../ssh
	github.com/james00012/terratest-modularization-test/modules/terraform => ../terraform
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
