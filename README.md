# CentralAccessDB — Database DevOps / CI-CD

A **state-based SQL Server database project** that captures the schema of the manually
built `CentralAccessDB` as source-controlled, file-per-object T-SQL. The live database is
the source of truth; this repo lets you **build** a deployable artifact (`.dacpac`),
**compare** it to any target/older database, and **generate the exact migration script**
to bring that target up to date — the foundation for a CI/CD pipeline.

## How it works (state-based / declarative)

```
  live CentralAccessDB ──(1_extract.ps1)──▶  src/CentralAccessDB/**/*.sql   (source of truth)
                                                    │
                                              (2_build.ps1 = dotnet build)
                                                    ▼
                                         bin/Release/CentralAccessDB.dacpac
                                                    │
                        (3_compare.ps1)  ┌────────────┴─────────────┐  (4_deploy.ps1)
                                       ▼                            ▼
                              migration_*.sql  (the diff)   published to target DB
```

You describe the *desired end state* (the `.sql` files); SqlPackage computes the diff
against whatever the target currently is and produces the migration script. No hand-written
`ALTER` migration files to maintain.

---

## 🟢 Non-technical users — start here

If you are not a developer and just need to run this, follow the plain-language, step-by-step
**[User Manual → `USERMANUAL.md`](USERMANUAL.md)**. It covers downloading the files, opening
PowerShell, installing the tools once, and updating a database safely (with a preview and a
type-`YES` confirmation).

The sections below are the **technical reference** for developers.

---

## Prerequisites

Run **`0_check_prerequisites.ps1`** first — it checks the machine for everything below and,
for any missing **required** tool, downloads and installs it (winget where possible, else the
official Microsoft install script), showing each step in colour with an `OK / MISSING /
INSTALLED / FAILED` status and a final summary.

```powershell
.\scripts\0_check_prerequisites.ps1                     # check + install missing (asks before each)
.\scripts\0_check_prerequisites.ps1 -CheckOnly          # report only, install nothing
.\scripts\0_check_prerequisites.ps1 -IncludeOptional -Force   # install everything, no prompts
```

Machine-wide installs (the .NET SDK) may prompt for elevation — run PowerShell **as
Administrator** for the smoothest experience. Installing the SDK / SqlPackage needs internet access.

| Tool | Version found | Required | Install |
|------|---------------|----------|---------|
| .NET SDK | 10.0.200 | yes | https://dotnet.microsoft.com |
| SqlPackage | 170.4.83 | yes | `dotnet tool install --global microsoft.sqlpackage` |
| sqlcmd | 15.0 | optional | part of SQL Server client tools |
| Git | 2.x | optional | https://git-scm.com |

## Repository layout

```
src/CentralAccessDB/
  CentralAccessDB.sqlproj        SDK-style project (Microsoft.Build.Sql 2.2.0), targets SQL Server 2019
  CentralAccessDB.publish.xml    Shared, safe-by-default deployment options
  Security/                      Schema definitions (FA_Ref, FA_Tran)
  Storage/                       XTP memory-optimized filegroup
  dbo/  FA_Ref/  FA_Tran/        Tables / StoredProcedures / Functions / Views / Synonyms
scripts/                         (run in numbered order; _Common is a shared helper, not a step)
  _Common.ps1                    Shared helpers (sqlpackage lookup, connection strings, secrets)
  0_check_prerequisites.ps1      Check the machine and install missing tools (.NET SDK, SqlPackage, ...)
  1_extract.ps1                  Refresh the project from the live source DB
  2_build.ps1                    dotnet build -> dacpac
  3_compare.ps1                  Generate migration script + change report vs a target DB (read-only)
  4_deploy.ps1                   Preview changes, ask you to confirm (type YES), then migrate
artifacts/                       Generated migration scripts / reports (git-ignored)
```

## Source database

- **Server:** `10.4.1.180`  **Database:** `CentralAccessDB`  **Engine:** SQL Server 2019 (15.0)
- **Objects captured:** 84 tables, 247 stored procedures, 4 scalar functions, 1 view, 3 synonyms
  across schemas `dbo`, `FA_Ref`, `FA_Tran` (342 `.sql` files).

> **Credentials are never stored in this repo.** Pass them via `-Password` or, preferably,
> environment variables: `SOURCE_DB_PASSWORD` (new/source DB) and `TARGET_DB_PASSWORD` (old/target DB).

## Usage

```powershell
# 0. One-time on a new machine: check + install the required tools
.\scripts\0_check_prerequisites.ps1

# 1. Refresh the project from the live source DB (re-run whenever the DB changes)
$env:SOURCE_DB_PASSWORD = '<source-password>'
.\scripts\1_extract.ps1
git diff                      # review schema changes before committing

# 2. Build the deployable artifact
.\scripts\2_build.ps1

# 3. Compare against the OLD database and GET THE MIGRATION SCRIPT (nothing is applied)
$env:TARGET_DB_PASSWORD = '<target-password>'
.\scripts\3_compare.ps1 -TargetServer <oldServer> -TargetDatabase <oldDb> -TargetUser <user>
#   -> artifacts\migration_<oldDb>_<timestamp>.sql   (the diff to review)
#   -> artifacts\changereport_<oldDb>_<timestamp>.xml

# 4. Migrate: previews the changes, asks you to type YES, then applies (all in one run)
.\scripts\4_deploy.ps1 -TargetServer <oldServer> -TargetDatabase <oldDb> -TargetUser <user>
#   -> shows CHANGE SUMMARY + a PREVIEW banner, then: "Type YES to migrate"
.\scripts\4_deploy.ps1 -TargetServer <oldServer> -TargetDatabase <oldDb> -TargetUser <user> -Force   # skip the prompt (automation/CI)
```

Omit `-TargetUser` to use Windows integrated authentication.

## Deployment safety (`CentralAccessDB.publish.xml`)

Defaults are conservative:

- `BlockOnPossibleDataLoss = True` — abort rather than risk data loss.
- `DropObjectsNotInSource = False` — objects present in the target but not in the project are
  **left alone**. Set `True` only when you deliberately want the target to become an exact
  mirror of the project (this drops extra objects and can lose data).
- Logins/users/permissions are excluded (only application-scoped schema was extracted). Manage
  security separately.

## Known findings / tech debt discovered during extraction

These are faithfully represented from the source DB and do **not** block build or deploy
(SQL Server uses deferred name resolution), but they are worth addressing:

1. **Stored procedures reference 6 tables that do not exist in `CentralAccessDB`:**
   `dbo.BillHeader`, `dbo.PayTrans`, `dbo.PaymentTypes`, `dbo.Location_Ref`,
   `dbo.UserWiseOutlet`, `dbo.Central_PasswordPolicyAttribute`.
   Those procs will fail at runtime unless the tables exist in the target environment or
   belong to another database. Decide whether to add the tables, add a database reference,
   or fix the procedures.
2. **Synonyms point at an external database `[Common]`** (`InsertAuditMaster`,
   `ValidateOnDelete`, `CheckApprovalsForMasterData`). The cross-database references are
   intentionally unresolved. To validate them at build time, add a `[Common]` database
   reference (a `Common.dacpac`) to the project.
3. **In-Memory OLTP filegroup `XTP`** (`Storage/XTP.sql`) exists but no memory-optimized
   tables currently use it. If a target instance/edition can't host `MEMORY_OPTIMIZED_DATA`,
   exclude it at deploy time (e.g. `Storage` object type) or drop the filegroup from the project.
4. **Suppressed build warnings** (see `.sqlproj`): `SQL71558` (~315 case-only reference
   mismatches — harmless under the case-insensitive collation), `SQL71501`/`SQL71562`
   (the intentional `[Common]` cross-db references).

## Next step: CI/CD pipeline

The pieces a pipeline needs are already here (`dotnet build` → dacpac → SqlPackage script/publish).
When you're ready to automate, a pipeline typically:

1. `dotnet build src/CentralAccessDB` to produce the dacpac (fails the build on real errors).
2. Runs `3_compare.ps1` against the target and publishes `migration_*.sql` as a build artifact for review.
3. On approval, runs `4_deploy.ps1 -Force` against the target (credentials from the pipeline's
   secret store, not source control).

GitHub Actions or Azure DevOps YAML can be added on request.
