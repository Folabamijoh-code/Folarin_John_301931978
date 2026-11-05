# Portfolio 1 — Database Design and Modelling

I organised the data into members, exercises, workouts, workout_sets. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| members | 2 |
| exercises | 2 |
| workouts | 2 |
| workout_sets | 2 |

The 32 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Folarin_John_301931978_P1_Design.md)
- [ER diagram](Folarin_John_301931978_P1_ERDiagram.md)
- [Normalisation](Folarin_John_301931978_P1_Normalisation.md)
- [Schema](Folarin_John_301931978_P1_Schema.sql)
- [Sample data](Folarin_John_301931978_P1_SampleData.sql)
- [Constraint tests](Folarin_John_301931978_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Folarin_John_301931978_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

