# Security Policy

- Gervi Héra Vitr offers NO security guarantees of any kind.
- All code changes require a pull request approval from an existing member.
- Gervi Héra Vitr is **an education institution** and does not offer any security services. 

Organization-wide security policies are applicable to this project and are a part of the [parent organization `fluffle` repository](https://github.com/Mimis-Gildi/fluffle).

Immediate Class Resources:

- [Project Management Site](https://github.com/orgs/Gervi-Hera-Vitr/projects/1 "Gervi Héra Viskr Learning Trails"): _Gervi Héra Viskr Learning Trails_.
- [Codacy Organization Dashboard](https://app.codacy.com/organizations/gh/Gervi-Hera-Vitr/dashboard "Codacy Organization Dashboard")
  - [Codacy Labs repository Security Report](https://app.codacy.com/gh/Gervi-Hera-Vitr/sindri-labs/dashboard "Codacy Security Report")
- [Mend Renovate Organization Dashboard](https://developer.mend.io/github/Gervi-Hera-Vitr "Mend.io: Renovate Security Report")
  - [Renovate Repository Dashboard](https://developer.mend.io/github/Gervi-Hera-Vitr/sindri-labs "Google AI Labs Dashboard")

## Factor 12

- [**Mímis Gildi**](https://qodana.cloud/organizations/AY0jm "Qodana") - GH-App [_Qodana Cloud_](https://qodana.cloud/) -  _**Organization**_ Dashboard;
  - [_**The Scene**_](https://qodana.cloud/teams/zqLmn "The Scene") Qodana _**Team**_ Dashboard.
- [**Mímis Gildi**](https://app.codacy.com/organizations/gh/Gervi-Hera-Vitr/dashboard "Codacy") - GH-App [_Codacy Production_](https://www.codacy.com/) -  _**Organization**_ Dashboard;
  - [_**Sindri Labs**_](https://app.codacy.com/gh/Gervi-Hera-Vitr/sindri-labs/dashboard "Sindri Labs") Codacy _**Repository**_ Dashboard.
- [**Mímis Gildi**](https://developer.mend.io/github/Gervi-Hera-Vitr "Mend.io") - GH-App [_Mend.io Renovate_](https://developer.mend.io/) -  _**Organization**_ Dashboard;
  - [_**Sindri Labs**_](https://developer.mend.io/github/Gervi-Hera-Vitr/sindri-labs "Sindri Labs") Mend.io _**Repository**_ Dashboard;
  - [_Current Issue (252) Dashboard_](https://github.com/Gervi-Hera-Vitr/sindri-labs/issues/252 "Dependency Dashboard #252"), GH local.
- [**Sindri Labs**](https://github.com/Gervi-Hera-Vitr/sindri-labs/security/dependabot "Mímis Gildi") - GH-Builtin-App [_Dependabot_](https://github.com/dependabot "Dependabot") - _**Repository**_ Dashboard;
  - Sindri Labs cumulative [_security panel_](https://github.com/Gervi-Hera-Vitr/sindri-labs/security) - _GH Dashboard.
- **Mímis Gildi** [Actions Ops](./.github) GitHub Actions Extensions -- see [_**dedicated runners**_](https://github.com/Mimis-Gildi/organization-runners "Mímis Gildi and dependent organizations Dedicated self-hosted Runners").

<small><strong>Disclaimer</strong>: AI augmentation is not documented.
The school curriculum or operations are not dependent on such automation.
Please ignore anything that starts with `io.matilda`.</small>

## Local Ops and Maintenance

Some operations are helpful to run on a regular basis @ `local`.
Most necessary upkeep is performed by the GitHub Actions aforementioned.
Content is validated, edited, and corrected independently of any actions.
Here are some of the things we benefit from doing locally:

### Upgrade your Gradle Wrapper

```zsh
# Upgrade your Gradle Wrapper to latest with 'all' distribution type
gradle wrapper --gradle-version latest --distribution-type all
```

### Manually Check the Gradle Dependencies

```zsh
# Check the Gradle project outdated dependencies
gradle --quiet --build-cache --no-daemon dependencyUpdates
```

Hint: search output fof 'The following dependencies have later milestone versions.'
Hint: `kotlin-dsl` version forcing is not required here yet.

___

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/de545692d2054bf7a4a6ccff66783bd1)](https://app.codacy.com/gh/Gervi-Hera-Vitr/sindri-labs/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

