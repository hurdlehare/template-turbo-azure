# Turborepo starter

> [!WARNING]
> This is a work in progress!

**Goals**:

- [ ] `apps/cli` - CLI template
- [ ] `apps/func-app` - Azure Function App template
- [ ] `apps/web-app` - Azure Web App template

- [ ] `packages/env` - Environment utilities
- [ ] `packages/eslint-config` - Linting
- [ ] `packages/tsconfig` - Typechecking
- [ ] `packages/ui` - UI components
- [ ] `packages/vitest-config` - Testing
- [ ] `packages/zod` - Validation

- [ ] `.github/workflows` - CI/CD

- [ ] `infra` - Infrastructure as Code (IaC)
- [ ] `docs` - Documentation

- [ ] Tools for [code generation](https://turborepo.com/docs/guides/generating-code)

<!-- toc -->

- [Technologies](#technologies)
    - [Prettier](#prettier)
        - [Imports](#imports)

<!-- tocstop -->

## Technologies

- [turborepo](https://turbo.build/repo/docs)
- [pnpm](https://pnpm.io/)
- [Azure](https://azure.microsoft.com/)
- [OpenTofu](https://opentofu.org/)
- [Prettier](https://prettier.io/)
- [ESLint](https://eslint.org/)
- [knip](https://knip.dev/)
- [markdown-toc](

### Prettier

Additional plugins for Prettier include:

- [`package.json` sorting](https://github.com/matzkoh/prettier-plugin-packagejson)
- [JSDoc formatting](https://github.com/hosseinmd/prettier-plugin-jsdoc)

#### Imports

[IanVS/prettier-plugin-sort-imports](https://github.com/IanVS/prettier-plugin-sort-imports) is based on [@trivago/prettier-plugin-sort-imports](https://github.com/trivago/prettier-plugin-sort-imports), but adds additional features:

- Does not re-order across side-effect imports
- Combines imports from the same source
- Combines type and value imports (if `importOrderTypeScriptVersion` is set to "4.5.0" or higher)
- Groups type imports with `<TYPES>` keyword
- Sorts node.js builtin modules to top (configurable with `<BUILTIN_MODULES>` keyword)
- Supports custom import order separation
- Handles comments around imports correctly
- Simplifies options for easier configuration
