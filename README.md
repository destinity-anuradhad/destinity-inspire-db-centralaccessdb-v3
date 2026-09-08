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

## 🟢 Simple step-by-step guide (no coding needed — start here)

This is for anyone on the IT team. You just run a few **ready-made scripts** by copy‑pasting one
line at a time. Nothing is changed on any database until you clearly type **YES**.

**What this tool does, in plain words:** it takes the latest database design and safely updates
an older copy of the database to match it — but first it **shows you exactly what will change**
and **asks you to confirm**.

**Good to know before you start**
- The screen uses colours: **green = success**, **yellow = a notice/warning**, **red = a problem**.
- Every script ends with a big **`STATUS: SUCCESS`** or **`STATUS: FAILED`** line, then
  **“Press any key to close…”** — press any key when you’re done reading.
- Every run also saves a log file in the **`logs`** folder. If you get stuck, send that file to a developer.
- You must be on the **office network / VPN** that can reach the database server, or it can’t connect.

### Step 1 — Get the files onto the computer
1. Open this page in a browser:
   `https://github.com/destinity-anuradhad/destinity-inspire-db-centralaccessdb-v3`
2. Click the green **`< > Code`** button → **Download ZIP**.
3. In your Downloads, **right‑click the ZIP → Extract All…** into a simple folder such as
   `C:\CentralAccessDB`. You should now have a folder that contains a **`scripts`** folder inside it.

### Step 2 — Open PowerShell inside that folder
1. Open the extracted folder in **File Explorer** (the one that has the `scripts` folder in it).
2. Click once in the **address bar** at the top (it shows the folder path).
3. Type `powershell` and press **Enter**. A dark blue window opens — that’s **PowerShell**.
4. To paste a line into it: **right‑click** inside the window (that pastes what you copied), then press **Enter**.

### Step 3 — First time only: install the tools it needs
Copy‑paste this line and press **Enter**:
```
powershell -ExecutionPolicy Bypass -File .\scripts\0_check_prerequisites.ps1
```
- It checks the computer and installs anything missing. If it asks a question, type **`Y`** and press Enter.
- If Windows shows a **“Do you want to allow this app…”** pop‑up, click **Yes**.
- When it finishes, read the **summary** — all green means you’re ready.
- If a **required** tool shows **`FAILED`**: close the window, then find **PowerShell** in the Start
  menu, **right‑click → Run as administrator**, and run the same line again.
- ✅ You only do Step 3 **once per computer**.

### Step 4 — Update a database (the main job)
Copy the line below, **replace the THREE capitalised words** with your details, then press **Enter**:
```
powershell -ExecutionPolicy Bypass -File .\scripts\4_deploy.ps1 -TargetServer SERVERNAME -TargetDatabase DATABASENAME -TargetUser LOGINNAME
```
Replace:
- **`SERVERNAME`** — the database server address (ask your DBA, e.g. `10.4.1.180`).
- **`DATABASENAME`** — the name of the database you want to update.
- **`LOGINNAME`** — your SQL Server login (username).

What happens next:
1. It **asks for your password** — type it (it stays hidden on screen) and press Enter.
2. It shows a **CHANGE SUMMARY** and a yellow **PREVIEW** banner — this lists what would be
   created, changed, or removed. **Nothing has been changed yet.**
3. To apply the changes, type **`YES`** (in capitals) and press Enter.
   To cancel and change nothing, just press **Enter** without typing anything.

> 💡 **Just want to see/save the changes without applying them?** Run the same line but with
> `3_compare.ps1` instead of `4_deploy.ps1`. It writes the update script into the **`artifacts`**
> folder and never touches the database.

### If something goes wrong
| You see… | What it usually means | What to do |
|----------|----------------------|------------|
| `running scripts is disabled on this system` | Windows is blocking scripts | Use the exact `powershell -ExecutionPolicy Bypass -File …` lines above — they avoid this. |
| Red text / `STATUS: FAILED` about **login/password** | Wrong username or password | Re‑run and re‑type the password carefully. |
| Red text about **connect / timeout** | Not reachable on the network | Connect to the office network / VPN, then try again. |
| A **required tool** is missing | Step 3 didn’t finish | Re‑run Step 3 (as administrator if needed). |

When in doubt, don’t type `YES` — nothing changes until you do. Then send the newest file from
the **`logs`** folder to a developer for help.

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
