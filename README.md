:star:
# star_plsql_utils
Various plsql procedures and functions

# Setup
```sql
SQL > @script.sql
```

# Functions
## apex_42_copy_ir
```sql
create or replace function apex_42_copy_ir (
    pUser           in  VARCHAR2,                   -- AKHTAR
    pReportID       in  NUMBER,                     -- 1235
    pAction         in  VARCHAR2                    -- I (Ignore) K (Keep Existing) R Replace Existing
)   return              VARCHAR2 is
```

## Todo
- [x] Initial setup
- [x] setup readme
- [x] function to copy APEX 4.2 IR from one user to another user
- [ ] next fun thing