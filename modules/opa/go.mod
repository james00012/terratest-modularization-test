module github.com/james00012/terratest-modularization-test/modules/opa

go 1.24.0

require (
	github.com/hashicorp/go-getter/v2 v2.2.3
	github.com/hashicorp/go-multierror v1.1.1
	github.com/james00012/terratest-modularization-test/modules/files v0.1.0
	github.com/james00012/terratest-modularization-test/modules/git v0.1.0
	github.com/james00012/terratest-modularization-test/modules/logger v0.1.0
	github.com/james00012/terratest-modularization-test/modules/shell v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
	github.com/stretchr/testify v1.11.1
)

require (
	github.com/bgentry/go-netrc v0.0.0-20140422174119-9fd32a8b3d3d // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/hashicorp/errwrap v1.0.0 // indirect
	github.com/hashicorp/go-cleanhttp v0.5.0 // indirect
	github.com/hashicorp/go-safetemp v1.0.0 // indirect
	github.com/hashicorp/go-version v1.1.0 // indirect
	github.com/klauspost/compress v1.11.2 // indirect
	github.com/mattn/go-zglob v0.0.2-0.20190814121620-e3c945676326 // indirect
	github.com/mitchellh/go-homedir v1.0.0 // indirect
	github.com/mitchellh/go-testing-interface v1.0.0 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/ulikunitz/xz v0.5.8 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace (
	github.com/james00012/terratest-modularization-test/modules/files => ../files
	github.com/james00012/terratest-modularization-test/modules/git => ../git
	github.com/james00012/terratest-modularization-test/modules/logger => ../logger
	github.com/james00012/terratest-modularization-test/modules/shell => ../shell
	github.com/james00012/terratest-modularization-test/modules/testing => ../testing
)
