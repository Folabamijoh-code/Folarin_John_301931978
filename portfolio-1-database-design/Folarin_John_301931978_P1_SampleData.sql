-- Fictional sample records for Fitness and Workout Tracking.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."members" ("member_id", "display_name", "email", "joined_on") VALUES (101, 'Avery Chen', 'avery.chen@example.test', '2025-01-15');
INSERT INTO portfolio."members" ("member_id", "display_name", "email", "joined_on") VALUES (102, 'Jordan Patel', 'jordan.patel@example.test', '2025-02-20');
INSERT INTO portfolio."exercises" ("exercise_id", "name", "category", "is_bodyweight") VALUES (201, 'Squat', 'strength', FALSE);
INSERT INTO portfolio."exercises" ("exercise_id", "name", "category", "is_bodyweight") VALUES (202, 'Push-up', 'bodyweight', TRUE);
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status") VALUES (301, 101, '2025-03-01T09:00:00Z', NULL, 'in_progress');
INSERT INTO portfolio."workouts" ("workout_id", "member_id", "started_at", "ended_at", "status") VALUES (302, 102, '2025-03-02T10:00:00Z', '2025-03-02T10:45:00Z', 'completed');
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg") VALUES (401, 301, 201, 1, 8, 40);
INSERT INTO portfolio."workout_sets" ("set_id", "workout_id", "exercise_id", "set_number", "reps", "load_kg") VALUES (402, 302, 202, 1, 12, 0);
COMMIT;
