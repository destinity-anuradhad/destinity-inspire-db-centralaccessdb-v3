---
name: sql-reviewer
description: Review SQL Server queries, stored procedures and database design.
---

When reviewing SQL:

- Prefer parameterized queries.
- Avoid SELECT *.
- Check execution-plan implications.
- Check missing or unnecessary indexes.
- Detect N+1 query patterns.
- Check datatype mismatches.
- Avoid functions on indexed WHERE columns when possible.
- Check transactions and error handling.
- Use TRY...CATCH where appropriate.
- Use SET NOCOUNT ON in stored procedures.
- Check SQL injection risks.
- Explain every performance recommendation.
