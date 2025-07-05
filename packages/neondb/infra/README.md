# Database Infrastructure as Code

Programmatically manage [Neon Postgres databases & compute](https://neon.com) using Azure for secret storage.

This package is an Azure implementation of an example application; when it was written (2025-07-05), it followed the [Neon Terraform provider's end-to-end example AWS application](https://registry.terraform.io/providers/kislerdm/neon/latest/docs/guides/e2e-example).

> [!TIP]
> Add Terraform import blocks above each Neon resource to import existing Neon resources into your Terraform state. `main.tf` should import everything that Neon gives you out of the box (i.e. two branches, one database, auth roles, etc). 

## Configuration

1. Configure the Neon provider:

```bash
export NEON_API_KEY=
```

2. and the Azure provider:

```bash
export ARM_TENANT_ID=
export ARM_SUBSCRIPTION_ID=
```

> [!TIP]- Use a tool like `direnv` to dynamically set environment variables based on the current directory.
>
> My `.envrc` file looks like this:
>
> ```bash
> export NEON_API_KEY=
> export ARM_TENANT_ID=
> export ARM_SUBSCRIPTION_ID=
> ```
>
> And when I `cd` into the directory, `direnv` automatically exports the variables:
> 
> ```bash
> direnv: export +ARM_SUBSCRIPTION_ID +ARM_TENANT_ID +NEON_API_KEY
> ```
>

3. Ensure a `terraform.tfvars` file exists with the contents of `variables.tf`:

```hcl
application        = "example"
environment        = "Development"
environment_short  = "dev"
location           = "West US 2"
location_short     = "wus2"
```
