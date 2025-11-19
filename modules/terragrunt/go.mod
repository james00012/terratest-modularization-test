module github.com/james00012/terratest-modularization-test/modules/terragrunt

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/internal/lib v1.0.0
	github.com/james00012/terratest-modularization-test/modules/files v1.0.0
	github.com/james00012/terratest-modularization-test/modules/logger v1.0.0
	github.com/james00012/terratest-modularization-test/modules/retry v1.0.0
	github.com/james00012/terratest-modularization-test/modules/shell v1.0.0
	github.com/james00012/terratest-modularization-test/modules/testing v1.0.0
	github.com/stretchr/testify v1.11.1
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/mattn/go-zglob v0.0.2-0.20190814121620-e3c945676326 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	golang.org/x/net v0.47.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace (
	github.com/james00012/terratest-modularization-test/internal/lib => ../../internal/lib
	github.com/james00012/terratest-modularization-test/modules/files => ../files
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/random => ../random
	github.com/james00012/terratest-modularization-test/modules/retry => ../retry
	github.com/james00012/terratest-modularization-test/modules/shell => ../shell
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
