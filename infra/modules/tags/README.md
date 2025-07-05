# tags

`tags` describe WHERE to look, WHO to contact, and WHEN to act; most of this information is project-specific.

This module manages the following tags:

| Label                 | Description                                                                 | Example                  | Default                                |
| --------------------- | --------------------------------------------------------------------------- | ------------------------ | -------------------------------------- |
| `Application`         | Name of the workload that the resource supports.                            | `"MyApp"`                | ``                                     |
| `BusinessCriticality` | Business impact of the resource or supported workload.                      | `"High"`                 | ``                                     |
| `BusinessUnit`        | Business unit that owns the resource or supported workload.                 | `"Engineering"`          | ``                                     |
| `CreatedBy`           | Creator of the cloud resource (e.g. Azure service principal or user).       | `"user@directory.com"`   | ``                                     |
| `CreatedAt`           | Date and time when the resource was created.                                | `"2023-10-01T12:00:00Z"` | `time_static.current_datetime.rfc3339` |
| `DataSensitivity`     | Sensitivity of data that the resource or workload handles.                  | `"Confidential"`         | ``                                     |
| `Environment`         | Environment in which the resource or workload operates.                     | `"Production"`           | ``                                     |
| `GithubOwner`         | Organization name or username of the owner of the GitHub repository.        | `"my-org"`               | ``                                     |
| `GithubRepository`    | Name of the repository in GitHub.                                           | `"my-repo"`              | ``                                     |
| `MaintainerEmail`     | Email address of the resource owner or maintainer.                          | `"example@test.com"`     | ``                                     |
| `Project`             | Name of the project or initiative that the resource or workload is part of. | `"MyProject"`            | `"Example"`                            |

## Enums

The following enums are used to define the values for the tags:

| Label                 | Options                                                                             |
| --------------------- | ----------------------------------------------------------------------------------- |
| `BusinessCriticality` | `Low` \| `Medium` \| `High` \| `BusinessUnitCritical` \| `MissionCritical`          |
| `BusinessUnit`        | `Engineering` \| `Finance` \| `HumanResources` \| `Legal` \| `Marketing` \| `Sales` |
| `DataSensitivity`     | `Public` \| `Internal` \| `Confidential` \| `HighlyConfidential`                    |
| `Environment`         | `Production` \| `Staging` \| `Development`                                          |

### BusinessCriticality

| Label                  | Description                                                           |
| ---------------------- | --------------------------------------------------------------------- |
| `Low`                  | Minimal impact on the business - e.g. non-critical application        |
| `Medium`               | Moderate impact on the business - e.g. internal application           |
| `High`                 | Significant impact on the business - e.g. customer-facing application |
| `BusinessUnitCritical` | Critical to the business unit - e.g. finance application              |
| `MissionCritical`      | Critical to the entire organization - e.g. core application           |

### BusinessUnit

| Label            | Description                       |
| ---------------- | --------------------------------- |
| `Engineering`    | Engineering department            |
| `Finance`        | Finance and Accounting department |
| `HumanResources` | HR department                     |
| `Legal`          | Legal department                  |
| `Marketing`      | Marketing department              |
| `Sales`          | Sales department                  |

### DataSensitivity

| Label                | Description                                                                  |
| -------------------- | ---------------------------------------------------------------------------- |
| `Public`             | Publicly available data - e.g. public website                                |
| `Internal`           | General data - e.g. internal documentation                                   |
| `Confidential`       | Personally identifiable information (PII) - e.g. name, address, phone number |
| `HighlyConfidential` | Sensitive PII - e.g. SSN, credit card numbers                                |

### Environment

| Label         | Description                                       | Shorthand |
| ------------- | ------------------------------------------------- | --------- |
| `Production`  | Production environment - e.g. live server         | `prod`    |
| `Staging`     | Staging environment - e.g. pre-production server  | `stage`   |
| `Development` | Development environment - e.g. development server | `dev`     |
