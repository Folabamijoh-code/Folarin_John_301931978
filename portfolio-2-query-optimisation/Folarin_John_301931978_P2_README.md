# Fitness and Workout Tracking — SQL queries

## 1. Show related members, workouts, workout_sets, exercises records (up to 20).

```sql
SELECT t0."member_id" AS "members_member_id",
       t0."display_name" AS "members_display_name",
       t1."workout_id" AS "workouts_workout_id",
       t1."started_at" AS "workouts_started_at",
       t2."set_id" AS "workout_sets_set_id",
       t2."set_number" AS "workout_sets_set_number",
       t3."exercise_id" AS "exercises_exercise_id",
       t3."name" AS "exercises_name"
FROM portfolio."members" t0
JOIN portfolio."workouts" t1 ON t1."member_id" = t0."member_id"
JOIN portfolio."workout_sets" t2 ON t2."workout_id" = t1."workout_id"
JOIN portfolio."exercises" t3 ON t2."exercise_id" = t3."exercise_id"
ORDER BY t0."member_id", t1."workout_id", t2."set_id", t3."exercise_id"
LIMIT 20;
```

| members_member_id | members_display_name | workouts_workout_id | workouts_started_at | workout_sets_set_id | workout_sets_set_number | exercises_exercise_id | exercises_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 101 | Avery Chen | 301 | 2025-03-01T09:00:00+00:00 | 401 | 1 | 201 | Squat |
| 102 | Jordan Patel | 302 | 2025-03-02T10:00:00+00:00 | 402 | 1 | 202 | Push-up |

## 2. Find members records where display_name matches "Avery Chen" (up to 20).

```sql
SELECT * FROM portfolio."members"
WHERE "display_name" IS NOT DISTINCT FROM 'Avery Chen'
ORDER BY "member_id"
LIMIT 20;
```

| member_id | display_name | email | joined_on |
| --- | --- | --- | --- |
| 101 | Avery Chen | avery.chen@example.test | 2025-01-15 |

## 3. Count workouts records for each member_id (up to 20 groups).

```sql
SELECT "member_id", count(*) AS record_count
FROM portfolio."workouts"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;
```

| member_id | record_count |
| --- | --- |
| 101 | 1 |
| 102 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.738 | 2.738, 2.694, 2.753 | Sort → Seq Scan | 274 |
| After index | 0.363 | 0.364, 0.362, 0.363 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.738 ms to 0.363 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.708..2.71 rows=50 loops=1)
  Seq Scan on workouts (actual time=0.016..2.658 rows=50 loops=1)
Planning Time: 0.452 ms
Execution Time: 2.738 ms
```

### Before index, run 2

```text
Sort (actual time=2.659..2.662 rows=50 loops=1)
  Seq Scan on workouts (actual time=0.017..2.609 rows=50 loops=1)
Planning Time: 0.423 ms
Execution Time: 2.694 ms
```

### Before index, run 3

```text
Sort (actual time=2.717..2.72 rows=50 loops=1)
  Seq Scan on workouts (actual time=0.017..2.664 rows=50 loops=1)
Planning Time: 0.435 ms
Execution Time: 2.753 ms
```

### After index, run 1

```text
Sort (actual time=0.295..0.298 rows=50 loops=1)
  Bitmap Heap Scan on workouts (actual time=0.036..0.243 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.02 rows=50 loops=1)
Planning Time: 0.748 ms
Execution Time: 0.364 ms
```

### After index, run 2

```text
Sort (actual time=0.291..0.294 rows=50 loops=1)
  Bitmap Heap Scan on workouts (actual time=0.036..0.239 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=50 loops=1)
Planning Time: 0.761 ms
Execution Time: 0.362 ms
```

### After index, run 3

```text
Sort (actual time=0.294..0.297 rows=50 loops=1)
  Bitmap Heap Scan on workouts (actual time=0.037..0.241 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=50 loops=1)
Planning Time: 0.761 ms
Execution Time: 0.363 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Folarin_John_301931978_P2_Queries.sql, then Folarin_John_301931978_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Folarin_John_301931978_P2_QueryResults.png) · [Index comparison](screenshots/Folarin_John_301931978_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

