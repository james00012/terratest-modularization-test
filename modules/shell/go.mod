module github.com/james00012/terratest-modularization-test/modules/shell

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/logger v1.0.0
	github.com/james00012/terratest-modularization-test/modules/random v1.0.0
	github.com/james00012/terratest-modularization-test/modules/testing v1.0.0
	github.com/stretchr/testify v1.11.1
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/kr/text v0.2.0 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace (
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/random => ../random
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
