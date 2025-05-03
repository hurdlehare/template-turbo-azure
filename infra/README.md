# Infrastructure as Code (IaC) for Azure

This directory contains OpenTofu (Terraform) configurations for infrastructure on Azure. If you're new to OpenTofu/Terraform and want to get started creating infrastructure, please check out [Getting Started](https://learn.hashicorp.com/terraform#getting_started).

> [!TIP]
> OpenTofu is a fork of Terraform that we use to manage our infrastructure. There may be small differences
> between Terraform and OpenTofu, but the OpenTofu project is open source and doesn't carry the risk of being
> closed or commercialized. See OpenTofu's [manifesto](https://opentofu.org/manifesto/) for more info.

## Table of Contents

<!-- toc -->

- [Installation](#installation)
- [Usage](#usage)
    - [Environment](#environment)
    - [Configuration](#configuration)
    - [Planning](#planning)
    - [Applying](#applying)
- [Background](#background)
- [Conventions](#conventions)
    - [Naming](#naming)
    - [AVM](#avm)
- [Deployment](#deployment)
    - [Style](#style)
        - [Arguments](#arguments)
            - [Incorrect](#incorrect)
            - [Correct](#correct)
        - [Ordering](#ordering)
        - [Separation](#separation)

<!-- tocstop -->

## Installation

- Install [OpenTofu](https://opentofu.org/docs/intro/install/) on your machine.
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) to authenticate with Azure.

## Usage

When running `tofu`:

- **Locally**: authenticate using the Azure CLI. See [Azure CLI authentication](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli) for more info.
- **In CI/CD**: authenticate using a Managed Identity (specifically, a system-assigned identity). See [Managed Identity](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) for more info.

### Environment

1. Set up environment variables in `.env`.
2. Run `source .env` to load the environment variables.

> [!TIP]
> See [`.env.example`](./environments/prod/.env.example) for environment variable names and example values.

### Configuration

1. Run `tofu init` to initialize the Terraform configuration.
2. Make your modifications to the configuration files as needed.

### Planning

1. Run `tofu plan` to see the changes that will be applied.
2. Review Terraform's summary of changes.

### Applying

1. Run `tofu apply` to apply the changes.
2. Confirm the changes by typing `yes` when prompted.
3. Repeat `tofu plan` and `tofu apply` as needed until the desired state is reached.

## Background

The `infra` directory wouldn't work out of the box in a fresh Azure subscription; it relies on the following to be in place already:

1. `00-backend.tf`:

- A **random 3-character string** unique to the OpenTofu state container: `"random_string"`
- A **resource group** for the resources required to host our own OpenTofu state container: `"rg-tfstate-${var.environment}-${random_string.resource_id_tfstate.result}"`
- A **storage account** for the OpenTofu state container: `"sttfstate${random_string.resource_id_tfstate.result}"`
- One or more **firewall rules** containing the IP addresses of any machines that will be running OpenTofu
- The **storage container** within the storage account we created above: `"stg-tfstate-${var.environment}-${random_string.resource_id_tfstate.result}"`

2. `00-provider.tf`:

- The **Azure Resource Manager (ARM) provider** with the correct version: `azurerm`
- The **backend block commented out**:

```tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "x.x.x"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "rg-tfstate-prod-XXX"
  #   storage_account_name = "sttfstateXXX"
  #   container_name       = "stg-tfstate-prod-XXX"
  #   key                  = "terraform.tfstate"
  # }
}
provider "azurerm" {
  features {}
}
```

> [!NOTE]
> This is commented out for the initial setup of the OpenTofu state container, but later, we'll uncomment
> it and replace the `XXX` with the `${random_string.resource_id_tfstate.result}`:

3. `00-variables.tf`:

- The `"environment"` variable (`TF_VAR_environment`)
- The `"azure_region"` variable (`TF_VAR_azure_region`)

4. `00-constants.tf` (optional, but recommended):

- Shared `tags`, which are key-value pairs that can be applied to resources for organization.
- The `groups`, which are logical groupings of resources that are deployed together.
- Our `slots`, which define the slots we'll use for Azure App Services.

5. `00-prefixes.tf` (optional, but recommended):

- The `prefix` variable, which is a prefix used for naming resources according to Azure best practices
- Each resource has a different prefix.

6. An `.env` file in the root of the `infra/environments/prod` directory (see [`.env.example`](./environments/prod/.env.example) for an example):

- It should follow the format of the `.env.example` file, but with the correct values for your environment.
- Contains any variables defined in `00-variables.tf` (e.g. `"environment"` is set with `TF_VAR_environment`).
- Always `source .env` before running `tofu` commands.

You can then follow the [Usage](#usage) instructions to deploy the Terraform state container, at which point you should replace the `XXX` in the `backend` block with the `${random_string.resource_id_tfstate.result}`.

## Conventions

### Naming

Our resources should have [Cloud Adoption Framework (CAF) compliant](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) names. See [Define your naming convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-compute-and-web) for more info.

> `${resourceAbbreviation}-${applicationName}-${environmentAbbreviation}-${uniqueIdentifier}`

| Variable                  | Description                                | Example                  | Min Length | Max Length             |
| ------------------------- | ------------------------------------------ | ------------------------ | ---------- | ---------------------- |
| `resourceAbbreviation`    | Shorthand for the resource                 | `rg` (Resource Group)    | `2`        | `9`                    |
| `applicationName`         | Logical grouping a resource belongs to     | `search` (Search Engine) | `3`        | `resourceNameMax - 17` |
| `environmentAbbreviation` | `prod`, `stage`, `dev`, `qa`, `test`       | `prod` (Production)      | `2`        | `5`                    |
| `uniqueIdentifier`        | Random string of 3 alphanumeric characters | `1a9` (Random)           | `3`        | `3`                    |

**Example**: `rg-search-prod-1a9`

See: https://registry.terraform.io/modules/Azure/naming/azurerm/latest#advanced-usage

### AVM

Where possible, we use [Azure Verified Modules for Terraform](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/#published-modules-----) for Azure-supported, ready-to-use Terraform modules. These modules are designed to be used in production and are supported by Microsoft. They are also compliant with the [Cloud Adoption Framework (CAF)](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview) and follow best practices for Azure resource management.

## Deployment

Ideally, we would use a CI/CD pipeline to deploy infrastructure changes. Our pipeline might look like this:

1. `on: pull_request` - Run `tofu plan` to show the changes that will be applied.
2. `on: push` - Run `tofu apply` to apply the changes.

However, we currently run our IaC locally.

### Style

See [Style Conventions](https://opentofu.org/docs/language/syntax/style/) in the OpenTofu documentation for idiomatic infrastructure as code.

Not all style conventions are enforced by the `tofu fmt` command. Outlined below are conventions that are not enforced by `tofu fmt` but are recommended for readability and maintainability.

#### Arguments

> When both arguments and blocks appear together inside a block body, place all of the arguments together at the top and then place nested blocks below them. Use one blank line to separate the arguments from the blocks.

##### Incorrect

The `instance_type` argument should be placed above the `network_interface` block:

```tf
resource "azurerm_example" "example" {
  example = "an example"
  block_example {
    # ...
  }
  another_example = "another example"
}
```

##### Correct

All arguments are placed before blocks.

```tf
resource "azurerm_example" "example" {
  example = "an example"
  another_example = "another example"
  block_example {
    # ...
  }
}
```

#### Ordering

> For blocks that contain both arguments and "meta-arguments" (as defined by the OpenTofu language semantics), list meta-arguments first and separate them from other arguments with one blank line. Place meta-argument blocks last and separate them from other blocks with one blank line.

```tf
resource "azurerm_example" "example" {
    count = 1

    example = "an example"
    another_example = "another example"
    block_example {
      # ...
    }

    lifecycle {
      ignore_changes = [example]
    }
}
```

#### Separation

> Top-level blocks should always be separated from one another by one blank line. Nested blocks should also be separated by blank lines, except when grouping together related blocks of the same type (like multiple provisioner blocks in a resource).

```tf
module "example" {
  source    = "./example"
}

resource "azurerm_example_resource_foo" "foo" {
  provisioner "local-exec" {
    command = "first"
  }
  provisioner "local-exec" {
    command = "second"
  }
}

resource "azurerm_example_resource_bar" "bar" {
    # ...
}
```
