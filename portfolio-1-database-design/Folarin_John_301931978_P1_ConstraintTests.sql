-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. members pk. Expected: pk_members, SQLSTATE 23505.
INSERT INTO portfolio."members" ("member_id", "display_name", "email", "joined_on")
VALUES (101, 'Taylor Reed', 'taylor.reed@example.test', '2025-03-03');

-- 2. members unique. Expected: uq_members_0, SQLSTATE 23505.
INSERT INTO portfolio."members" ("member_id", "display_name", "email", "joined_on")
VALUES (1001, 'Taylor Reed', 'avery.chen@example.test', '2025-03-03');

-- 3. members nn id. Expected: member_id, SQLSTATE 23502.
INSERT INTO portfolio."members" ("member_id", "display_name", "email", "joined_on")
VALUES (NULL, 'Taylor Reed', 'taylor.reed@example.test', '2025-03-03');

-- 4. members nn name. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."members" ("member_id", "display_name", "email", "joined_on")
VALUES (1002, NULL, 'taylor.reed@example.test', '2025-03-03');

-- 5. members nn email. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."members" ("member_id", "display_name", "email", "joined_on")
VALUES (1003, 'Taylor Reed', NULL, '2025-03-03');

-- 6. members nn joined. Expected: joined_on, SQLSTATE 23502.
INSERT INTO portfolio."members" ("member_id", "display_name", "email", "joined_on")
VALUES (1004, 'Taylor Reed', 'taylor.reed@example.test', NULL);

-- 7. exercises pk. Expected: pk_exercises, SQLSTATE 23505.
INSERT INTO portfolio."exercises" ("exercise_id", "name", "category", "is_bodyweight")
VALUES (201, 'Lunge', 'strength', FALSE);

-- 8. exercises unique. Expected: uq_exercises_0, SQLSTATE 23505.
INSERT INTO portfolio."exercises" ("exercise_id", "name", "category", "is_bodyweight")
VALUES (1005, 'Squat', 'strength', FALSE);

-- 9. exercises nn id. Expected: exercise_id, SQLSTATE 23502.
INSERT INTO portfolio."exercises" ("exercise_id", "name", "category", "is_bodyweight")
VALUES (NULL, 'Lunge', 'strength', FALSE);

-- 10. exercises nn name. Expected: name, SQLSTATE 23502.
INSERT INTO portfolio."exercises" ("exercise_id", "name", "category", "is_bodyweight")
VALUES (1006, NULL, 'strength', FALSE);

-- 11. exercises nn category. Expected: category, SQLSTATE 23502.
INSERT INTO portfolio."exercises" ("exercise_id", "name", "category", "is_bodyweight")
VALUES (1007, 'Lunge', NULL, FALSE);

-- 12. exercises nn bodyweight. Expected: is_bodyweight, SQLSTATE 23502.
INSERT INTO portfolio."exercises" ("exercise_id", "name", "category", "is_bodyweight")
VALUES (1008, 'Lunge', 'strength', NULL);

-- 13. workouts pk. Expected: pk_workouts, SQLSTATE 23505.
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status")
VALUES (301, 102, '2025-03-03T08:00:00Z', '2025-03-03T08:30:00Z', 'completed');

-- 14. workouts fk member. Expected: fk_workouts_0, SQLSTATE 23503.
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status")
VALUES (1009, 90001, '2025-03-03T08:00:00Z', NULL, 'completed');

-- 15. workouts nn id. Expected: workout_id, SQLSTATE 23502.
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status")
VALUES (NULL, 102, '2025-03-03T08:00:00Z', NULL, 'completed');

-- 16. workouts nn member. Expected: member_id, SQLSTATE 23502.
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status")
VALUES (1010, NULL, '2025-03-03T08:00:00Z', NULL, 'completed');

-- 17. workouts nn started. Expected: started_at, SQLSTATE 23502.
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status")
VALUES (1011, 102, NULL, NULL, 'completed');

-- 18. workouts nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status")
VALUES (1012, 102, '2025-03-03T08:00:00Z', NULL, NULL);

-- 19. workouts check status. Expected: workout_status_check, SQLSTATE 23514.
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status")
VALUES (1013, 102, '2025-03-03T08:00:00Z', NULL, 'paused');

-- 20. workouts partial active. Expected: one_active_workout_per_member, SQLSTATE 23505.
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status")
VALUES (1014, 101, '2025-03-03T08:00:00Z', NULL, 'in_progress');

-- 21. sets pk. Expected: pk_workout_sets, SQLSTATE 23505.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (401, 302, 202, 2, 10, 0);

-- 22. sets unique. Expected: uq_workout_sets_0, SQLSTATE 23505.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1015, 301, 201, 1, 8, 40);

-- 23. sets fk workout. Expected: fk_workout_sets_0, SQLSTATE 23503.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1016, 90002, 201, 2, 8, 20);

-- 24. sets fk exercise. Expected: fk_workout_sets_1, SQLSTATE 23503.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1017, 301, 90003, 2, 8, 20);

-- 25. sets nn id. Expected: set_id, SQLSTATE 23502.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (NULL, 301, 201, 2, 8, 20);

-- 26. sets nn workout. Expected: workout_id, SQLSTATE 23502.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1018, NULL, 201, 2, 8, 20);

-- 27. sets nn exercise. Expected: exercise_id, SQLSTATE 23502.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1019, 301, NULL, 2, 8, 20);

-- 28. sets nn number. Expected: set_number, SQLSTATE 23502.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1020, 301, 201, NULL, 8, 20);

-- 29. sets nn reps. Expected: reps, SQLSTATE 23502.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1021, 301, 201, 2, NULL, 20);

-- 30. sets nn load. Expected: load_kg, SQLSTATE 23502.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1022, 301, 201, 2, 8, NULL);

-- 31. sets check reps. Expected: set_reps_positive, SQLSTATE 23514.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1023, 301, 201, 2, 0, 20);

-- 32. sets check load. Expected: set_load_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg")
VALUES (1024, 301, 201, 2, 8, -1);
