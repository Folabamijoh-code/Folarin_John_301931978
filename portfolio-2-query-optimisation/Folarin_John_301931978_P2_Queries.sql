-- Show related members, workouts, workout_sets, exercises records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find members records where display_name matches "Avery Chen" (up to 20).
SELECT * FROM portfolio."members"
WHERE "display_name" IS NOT DISTINCT FROM 'Avery Chen'
ORDER BY "member_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."members"
WHERE "display_name" IS NOT DISTINCT FROM 'Avery Chen'
ORDER BY "member_id"
LIMIT 20;

-- Count workouts records for each member_id (up to 20 groups).
SELECT "member_id", count(*) AS record_count
FROM portfolio."workouts"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "member_id", count(*) AS record_count
FROM portfolio."workouts"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;
