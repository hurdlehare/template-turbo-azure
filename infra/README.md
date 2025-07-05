# Infrastructure as Code (IaC) for Azure

This directory contains [OpenTofu](https://opentofu.org/manifesto/) (Terraform) configurations for infrastructure on Azure. If you're new to OpenTofu/Terraform and want to get started, check out [Terraform's Getting Started](https://learn.hashicorp.com/terraform#getting_started).

## Table of Contents

<!-- toc -->

- [Installation](#installation)
- [Usage](#usage)
    - [Environment](#environment)
    - [Configuration](#configuration)
    - [Planning](#planning)
    - [Applying](#applying)
- [Conventions](#conventions)
    - [Naming](#naming)
    - [AVM](#avm)
    - [Style](#style)

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

> [!TIP] Use a tool like [direnv](https://direnv.net/) to dynamically set environment variables based on the current directory.

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

## Conventions

### Naming

Resources should have [Cloud Adoption Framework (CAF) compliant](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) names. See [Define your naming convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-compute-and-web) for more info.

> `${prefix}-${application}-${environment_short}-${location_short}-${unique}`

| Variable           | Description                            | Example               | Min Length | Max Length             |
| ------------------ | -------------------------------------- | --------------------- | ---------- | ---------------------- |
| `prefix`           | Shorthand for the resource             | `rg` (Resource Group) | `2`        | `9`                    |
| `application`      | Logical grouping a resource belongs to | `jobs`                | `3`        | `resourceNameMax - 24` |
| `environment_short` | `prod`, `stage`, `dev`, `qa`, `test`   | `dev` (Development)   | `2`        | `5`                    |
| `location_short`    | `wus2`, `eus2`, etc.                   | `wus2` (West US 2)    | `3`        | `5`                    |
| `unique`           | Random string alphanumeric characters  | `jgtqs` (Random)      | `5`        | `5`                    |

**Example**: `rg-jobs-dev-wus2-jgtqs`

See: https://registry.terraform.io/modules/Azure/naming/azurerm/latest#advanced-usage

> > [!TIP]- Use the [Azure Resource Abbreviations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations) to create a prefix for your resources.
> 
> The following are the prefixes I use in my own projects:
> 
> ```hcl
> locals {
>   # Azure Resource Abbreviations
>   # https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations  prefixes = {
>   prefixes = {
>     # AI & Machine Learning
>     aISearch                      = "srch",
>     azureAIservices               = "ais",
>     azureAIFoundryhub             = "hub",
>     azureAIFoundryproject         = "proj",
>     azureAIVideoIndexer           = "avi",
>     azureMachineLearningworkspace = "mlw",
>     azureOpenAIService            = "oai",
>     botservice                    = "bot",
>     computervision                = "cv",
>     contentmoderator              = "cm",
>     contentsafety                 = "cs",
>     customvisionPrediction        = "cstv",
>     customvisionTraining          = "cstvt",
>     documentintelligence          = "di",
>     faceAPI                       = "face",
>     healthInsights                = "hi",
>     immersivereader               = "ir",
>     languageservice               = "lang",
>     speechservice                 = "spch",
>     translator                    = "trsl",
> 
>     # Analytics and IoT
>     azureAnalysisServicesserver           = "as",
>     azureDatabricksworkspace              = "dbw",
>     azureDataExplorercluster              = "dec",
>     azureDataExplorerclusterdatabase      = "dedb",
>     azureDataFactory                      = "adf",
>     azureDigitalTwininstance              = "dt",
>     azureStreamAnalytics                  = "asa",
>     azureSynapseAnalyticsprivatelinkhub   = "synplh",
>     azureSynapseAnalyticsSQLDedicatedPool = "syndp",
>     azureSynapseAnalyticsSparkPool        = "synsp",
>     azureSynapseAnalyticsworkspaces       = "synw",
>     dataLakeStoreaccount                  = "dls",
>     dataLakeAnalyticsaccount              = "dla",
>     eventHubsnamespace                    = "evhns",
>     eventhub                              = "evh",
>     eventGriddomain                       = "evgd",
>     eventGridsubscriptions                = "evgs",
>     eventGridtopic                        = "evgt",
>     eventGridsystemtopic                  = "egst",
>     hDInsight-Hadoopcluster               = "hadoop",
>     hDInsight-HBasecluster                = "hbase",
>     hDInsight-Kafkacluster                = "kafka",
>     hDInsight-Sparkcluster                = "spark",
>     hDInsight-Stormcluster                = "storm",
>     hDInsight-MLServicescluster           = "mls",
>     ioThub                                = "iot",
>     provisioningservices                  = "provs",
>     provisioningservicescertificate       = "pcert",
>     powerBIEmbedded                       = "pbi",
>     timeSeriesInsightsenvironment         = "tsi",
> 
>     # Compute and web
>     appServiceenvironment                  = "ase",
>     appServiceplan                         = "asp",
>     azureLoadTestinginstance               = "lt",
>     availabilityset                        = "avail",
>     azureArcenabledserver                  = "arcs",
>     azureArcenabledKubernetescluster       = "arck",
>     azureArcprivatelinkscope               = "pls",
>     azureArcgateway                        = "arcgw",
>     batchaccounts                          = "ba",
>     cloudservice                           = "cld",
>     communicationServices                  = "acs",
>     diskencryptionset                      = "des",
>     functionapp                            = "func",
>     gallery                                = "gal",
>     hostingenvironment                     = "host",
>     imagetemplate                          = "it",
>     manageddiskOS                          = "osdisk",
>     manageddiskData                        = "disk",
>     notificationHubs                       = "ntf",
>     notificationHubsnamespace              = "ntfns",
>     proximityplacementgroup                = "ppg",
>     restorepointcollection                 = "rpc",
>     snapshot                               = "snap",
>     staticwebapp                           = "stapp",
>     virtualmachine                         = "vm",
>     virtualmachinescaleset                 = "vmss",
>     virtualmachinemaintenanceconfiguration = "mc",
>     vMstorageaccount                       = "stvm",
>     webapp                                 = "app",
> 
>     # Containers
>     aKScluster                  = "aks",
>     aKSsystemnodepool           = "npsystem",
>     aKSusernodepool             = "np",
>     containerapps               = "ca",
>     containerappsenvironment    = "cae",
>     containerregistry           = "cr",
>     containerinstance           = "ci",
>     serviceFabriccluster        = "sf",
>     serviceFabricmanagedcluster = "sfmc",
> 
>     # Databases
>     azureCosmosDBdatabase                  = "cosmos",
>     azureCosmosDBforApacheCassandraaccount = "coscas",
>     azureCosmosDBforMongoDBaccount         = "cosmon",
>     azureCosmosDBforNoSQLaccount           = "cosno",
>     azureCosmosDBforTableaccount           = "costab",
>     azureCosmosDBforApacheGremlinaccount   = "cosgrm",
>     azureCosmosDBPostgreSQLcluster         = "cospos",
>     azureCacheforRedisinstance             = "redis",
>     azureSQLDatabaseserver                 = "sql",
>     azureSQLdatabase                       = "sqldb",
>     azureSQLElasticJobagent                = "sqlja",
>     azureSQLElasticPool                    = "sqlep",
>     mariaDBserver                          = "maria",
>     mariaDBdatabase                        = "mariadb",
>     mySQLdatabase                          = "mysql",
>     postgreSQLdatabase                     = "psql",
>     sQLServerStretchDatabase               = "sqlstrdb",
>     sQLManagedInstance                     = "sqlmi",
> 
>     # Developer tools
>     appConfigurationstore = "appcs",
>     mapsaccount           = "map",
>     signalR               = "sigr",
>     webPubSub             = "wps",
> 
>     # Dev Ops
>     azureManagedGrafana = "amg",
> 
>     # Integration
>     aPImanagementserviceinstance = "apim",
>     integrationaccount           = "ia",
>     logicapp                     = "logic",
>     serviceBusnamespace          = "sbns",
>     serviceBusqueue              = "sbq",
>     serviceBustopic              = "sbt",
>     serviceBustopicsubscription  = "sbts",
> 
>     # Management and governance
>     automationaccount                        = "aa",
>     azurePolicydefinition                    = "<descriptive>",
>     applicationInsights                      = "appi",
>     azureMonitoractiongroup                  = "ag",
>     azureMonitordatacollectionrule           = "dcr",
>     azureMonitoralertprocessingrule          = "apr",
>     blueprintPlannedfordeprecation           = "bp",
>     blueprintassignmentPlannedfordeprecation = "bpa",
>     datacollectionendpoint                   = "dce",
>     logAnalyticsworkspace                    = "log",
>     logAnalyticsquerypacks                   = "pack",
>     managementgroup                          = "mg",
>     microsoftPurviewinstance                 = "pview",
>     resourcegroup                            = "rg",
>     templatespecsname                        = "ts",
> 
>     # Migration
>     azureMigrateproject              = "migr",
>     databaseMigrationServiceinstance = "dms",
>     recoveryServicesvault            = "rsv",
> 
>     # Networking
>     applicationgateway                   = "agw",
>     applicationsecuritygroupASG          = "asg",
>     cDNprofile                           = "cdnp",
>     cDNendpoint                          = "cdne",
>     connections                          = "con",
>     dNS                                  = "<DNSdomainname>",
>     dNSforwardingruleset                 = "dnsfrs",
>     dNSprivateresolver                   = "dnspr",
>     dNSprivateresolverinboundendpoint    = "in",
>     dNSprivateresolveroutboundendpoint   = "out",
>     dNSzone                              = "<DNSdomainname>",
>     firewall                             = "afw",
>     firewallpolicy                       = "afwp",
>     expressRoutecircuit                  = "erc",
>     expressRoutedirect                   = "erd",
>     expressRoutegateway                  = "ergw",
>     frontDoorStandardPremiumProfile      = "afd",
>     frontDoorStandardPremiumEndpoint     = "fde",
>     frontDoorfirewallpolicy              = "fdfp",
>     frontDoorClassic                     = "afd",
>     iPgroup                              = "ipg",
>     loadbalancerInternal                 = "lbi",
>     loadbalancerExternal                 = "lbe",
>     loadbalancerrule                     = "rule",
>     localnetworkgateway                  = "lgw",
>     nATgateway                           = "ng",
>     networkinterfaceNIC                  = "nic",
>     networksecuritygroupNSG              = "nsg",
>     networksecuritygroupNSGSecurityrules = "nsgsr",
>     networkWatcher                       = "nw",
>     privateLink                          = "pl",
>     privateendpoint                      = "pep",
>     publicIPaddress                      = "pip",
>     publicIPaddressprefix                = "ippre",
>     routefilter                          = "rf",
>     routeserver                          = "rtserv",
>     routetable                           = "rt",
>     serviceendpointpolicy                = "se",
>     trafficManagerprofile                = "traf",
>     userdefinedrouteUDR                  = "udr",
>     virtualnetwork                       = "vnet",
>     virtualnetworkgateway                = "vgw",
>     virtualnetworkmanager                = "vnm",
>     virtualnetworkpeering                = "peer",
>     virtualnetworksubnet                 = "snet",
>     virtualWAN                           = "vwan",
>     virtualWANHub                        = "vhub",
> 
>     # Security
>     azureBastion                             = "bas",
>     keyvault                                 = "kv",
>     keyVaultManagedHSM                       = "kvmhsm",
>     managedidentity                          = "id",
>     sSHkey                                   = "sshkey",
>     vPNGateway                               = "vpng",
>     vPNconnection                            = "vcn",
>     vPNsite                                  = "vst",
>     webApplicationFirewallWAFPolicy          = "waf",
>     webApplicationFirewallWAFPolicyrulegroup = "wafrg",
> 
>     # Storage
>     azureStorSimple        = "ssimp",
>     backupVaultname        = "bvault",
>     backupVaultpolicy      = "bkpol",
>     fileshare              = "share",
>     storageaccount         = "st",
>     storageSyncServicename = "sss",
> 
>     # Virtual desktop infrastructure
>     virtualdesktophostpool         = "vdpool",
>     virtualdesktopapplicationgroup = "vdag",
>     virtualdesktopworkspace        = "vdws",
>     virtualdesktopscalingplan      = "vdscaling",
> 
>     # CUSTOM
>     # https://github.com/Azure/terraform-azurerm-naming/blob/master/resourceDefinition.json
>     storageContainer = "stct",
>     storageQueue     = "stq",
>     storageTable     = "stt"
>   }
> }
> ```
>

### AVM

Where possible, use [Azure Verified Modules for Terraform](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/#published-modules-----) for Azure-supported, ready-to-use Terraform modules. These modules are designed to be used in production and are supported by Microsoft. They are also compliant with the [Cloud Adoption Framework (CAF)](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview) and follow best practices for Azure resource management.

### Style

See [Style Conventions](https://opentofu.org/docs/language/syntax/style/) in the OpenTofu documentation for idiomatic infrastructure as code.

Not all style conventions are enforced by the `tofu fmt` command. Consider using a linter like [tflint](https://github.com/terraform-linters/tflint) to enforce style conventions.