module github.com/james00012/terratest-modularization-test/test-external

go 1.24.0

require (
	github.com/james00012/terratest-modularization-test/modules/collections v0.1.0
	github.com/james00012/terratest-modularization-test/modules/dns-helper v0.1.0-00010101000000-000000000000
	github.com/james00012/terratest-modularization-test/modules/environment v0.1.0-00010101000000-000000000000
	github.com/james00012/terratest-modularization-test/modules/git v0.1.0-00010101000000-000000000000
	github.com/james00012/terratest-modularization-test/modules/http-helper v0.1.0-00010101000000-000000000000
	github.com/james00012/terratest-modularization-test/modules/logger v0.1.0
	github.com/james00012/terratest-modularization-test/modules/oci v0.1.0-00010101000000-000000000000
	github.com/james00012/terratest-modularization-test/modules/ssh v0.1.0-00010101000000-000000000000
	github.com/james00012/terratest-modularization-test/modules/terragrunt v0.1.0
	github.com/james00012/terratest-modularization-test/modules/testing v0.1.0
	github.com/stretchr/testify v1.11.1
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/james00012/terratest-modularization-test/internal/lib v0.1.0 // indirect
	github.com/james00012/terratest-modularization-test/modules/files v0.1.0 // indirect
	github.com/james00012/terratest-modularization-test/modules/random v0.1.0 // indirect
	github.com/james00012/terratest-modularization-test/modules/retry v0.1.0 // indirect
	github.com/james00012/terratest-modularization-test/modules/shell v0.1.0 // indirect
	github.com/hashicorp/errwrap v1.0.0 // indirect
	github.com/hashicorp/go-multierror v1.1.1 // indirect
	github.com/mattn/go-zglob v0.0.2-0.20190814121620-e3c945676326 // indirect
	github.com/miekg/dns v1.1.68 // indirect
	github.com/oracle/oci-go-sdk v24.3.0+incompatible // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	golang.org/x/crypto v0.44.0 // indirect
	golang.org/x/mod v0.24.0 // indirect
	golang.org/x/net v0.47.0 // indirect
	golang.org/x/sync v0.14.0 // indirect
	golang.org/x/sys v0.38.0 // indirect
	golang.org/x/tools v0.33.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace (
	github.com/james00012/terratest-modularization-test/internal/lib => ../internal/lib
	github.com/james00012/terratest-modularization-test/modules/collections => ../modules/collections
	github.com/james00012/terratest-modularization-test/modules/dns-helper => ../modules/dns-helper
	github.com/james00012/terratest-modularization-test/modules/environment => ../modules/environment
	github.com/james00012/terratest-modularization-test/modules/files => ../modules/files
	github.com/james00012/terratest-modularization-test/modules/git => ../modules/git
	github.com/james00012/terratest-modularization-test/modules/http-helper => ../modules/http-helper
	github.com/james00012/terratest-modularization-test/modules/logger => ../modules/logger
	github.com/james00012/terratest-modularization-test/modules/oci => ../modules/oci
	github.com/james00012/terratest-modularization-test/modules/random => ../modules/random
	github.com/james00012/terratest-modularization-test/modules/retry => ../modules/retry
	github.com/james00012/terratest-modularization-test/modules/shell => ../modules/shell
	github.com/james00012/terratest-modularization-test/modules/ssh => ../modules/ssh
	github.com/james00012/terratest-modularization-test/modules/terragrunt => ../modules/terragrunt
	github.com/james00012/terratest-modularization-test/modules/testing => ../modules/testing
)
