module github.com/james00012/terratest-modularization-test/modules/ssh

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/collections v0.1.0
	github.com/james00012/terratest-modularization-test/modules/files v0.1.0
	github.com/james00012/terratest-modularization-test/modules/logger v0.1.0
	github.com/james00012/terratest-modularization-test/modules/retry v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
	github.com/hashicorp/go-multierror v1.1.1
	github.com/stretchr/testify v1.10.0
	golang.org/x/crypto v0.44.0
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/hashicorp/errwrap v1.0.0 // indirect
	github.com/mattn/go-zglob v0.0.2-0.20190814121620-e3c945676326 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	golang.org/x/net v0.47.0 // indirect
	golang.org/x/sys v0.38.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace (
	github.com/james00012/terratest-modularization-test/modules/collections => ../collections
	github.com/james00012/terratest-modularization-test/modules/files => ../files
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/retry => ../retry
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
