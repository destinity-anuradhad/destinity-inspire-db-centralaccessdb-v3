# CentralAccessDB — User Manual (Simple Guide)

**Who this is for:** anyone on the IT team — **no coding needed.** You just run a few
**ready‑made scripts** by copy‑pasting one line at a time.

**What this tool does, in plain words:** it takes the latest database design and safely updates
an older copy of the database to match it — but first it **shows you exactly what will change**
and **asks you to confirm.** Nothing on any database changes until you clearly type **`YES`**.

---

## Before you start — good to know

- The screen uses colours: **green = success**, **yellow = a notice/warning**, **red = a problem**.
- Every script ends with a big **`STATUS: SUCCESS`** or **`STATUS: FAILED`** line, then
  **“Press any key to close…”** — press any key when you have finished reading.
- Every run also saves a log file in the **`logs`** folder. If you get stuck, send that file to a developer.
- You must be on the **office network / VPN** that can reach the database server, or it cannot connect.

---

## Step 1 — Get the files onto the computer

1. Open this page in a browser:
   `https://github.com/destinity-anuradhad/destinity-inspire-db-centralaccessdb-v3`
2. Click the green **`< > Code`** button → **Download ZIP**.
3. In your Downloads, **right‑click the ZIP → Extract All…** into a simple folder such as
   `C:\CentralAccessDB`. You should now have a folder that contains a **`scripts`** folder inside it.

---

## Step 2 — Open PowerShell inside that folder

1. Open the extracted folder in **File Explorer** (the one that has the `scripts` folder in it).
2. Click once in the **address bar** at the top (it shows the folder path).
3. Type `powershell` and press **Enter**. A dark blue window opens — that is **PowerShell**.
4. To paste a line into it: **right‑click** inside the window (that pastes what you copied), then press **Enter**.

---

## Step 3 — First time only: install the tools it needs

Copy‑paste this line and press **Enter**:

```
powershell -ExecutionPolicy Bypass -File .\scripts\0_check_prerequisites.ps1
```

- It checks the computer and installs anything missing. If it asks a question, type **`Y`** and press Enter.
- If Windows shows a **“Do you want to allow this app…”** pop‑up, click **Yes**.
- When it finishes, read the **summary** — all green means you are ready.
- If a **required** tool shows **`FAILED`**: close the window, then find **PowerShell** in the Start
  menu, **right‑click → Run as administrator**, and run the same line again.

✅ You only do Step 3 **once per computer.**

---

## Step 4 — Update a database (the main job)

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

---

## If something goes wrong

| You see… | What it usually means | What to do |
|----------|----------------------|------------|
| `running scripts is disabled on this system` | Windows is blocking scripts | Use the exact `powershell -ExecutionPolicy Bypass -File …` lines above — they avoid this. |
| Red text / `STATUS: FAILED` about **login/password** | Wrong username or password | Re‑run and re‑type the password carefully. |
| Red text about **connect / timeout** | Not reachable on the network | Connect to the office network / VPN, then try again. |
| A **required tool** is missing | Step 3 did not finish | Re‑run Step 3 (as administrator if needed). |
| The **computer gets slow / CPU or RAM is high** while it runs | The build/compare work is heavy for a short time | This is normal **while a step is running** and settles when it finishes. If it stays slow, don’t run it **on the database server itself** — ask a developer to run it from a **different computer**, and prefer **outside busy hours**. |

When in doubt, **don’t type `YES`** — nothing changes until you do. Then send the newest file
from the **`logs`** folder to a developer for help.

> ⏳ **Note:** the very first run of **Step 3** downloads and installs tools, so it can be slow and
> use a lot of CPU **that one time** — this is expected and only happens once per computer.

---

*Developers: see [`README.md`](README.md) for the technical details, the full script reference,
deployment safety options, and CI/CD notes.*
