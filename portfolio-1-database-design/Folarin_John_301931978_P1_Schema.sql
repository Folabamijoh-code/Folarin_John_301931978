-- Fitness and Workout Tracking: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."members" (
  "member_id" bigint NOT NULL,
  "display_name" text NOT NULL,
  "email" text NOT NULL,
  "joined_on" date NOT NULL,
  CONSTRAINT "pk_members" PRIMARY KEY ("member_id"),
  CONSTRAINT "uq_members_0" UNIQUE ("email")
);
CREATE TABLE portfolio."exercises" (
  "exercise_id" bigint NOT NULL,
  "name" text NOT NULL,
  "category" text NOT NULL,
  "is_bodyweight" boolean NOT NULL,
  CONSTRAINT "pk_exercises" PRIMARY KEY ("exercise_id"),
  CONSTRAINT "uq_exercises_0" UNIQUE ("name")
);
CREATE TABLE portfolio."workouts" (
  "workout_id" bigint NOT NULL,
  "member_id" bigint NOT NULL,
  "started_at" timestamptz NOT NULL,
  "ended_at" timestamptz,
  "status" text NOT NULL,
  CONSTRAINT "pk_workouts" PRIMARY KEY ("workout_id")
);
CREATE TABLE portfolio."workout_sets" (
  "set_id" bigint NOT NULL,
  "workout_id" bigint NOT NULL,
  "exercise_id" bigint NOT NULL,
  "set_number" bigint NOT NULL,
  "reps" bigint NOT NULL,
  "load_kg" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_workout_sets" PRIMARY KEY ("set_id"),
  CONSTRAINT "uq_workout_sets_0" UNIQUE ("workout_id", "exercise_id", "set_number")
);
ALTER TABLE portfolio."workouts" ADD CONSTRAINT "fk_workouts_0" FOREIGN KEY ("member_id") REFERENCES portfolio."members" ("member_id");
ALTER TABLE portfolio."workout_sets" ADD CONSTRAINT "fk_workout_sets_0" FOREIGN KEY ("workout_id") REFERENCES portfolio."workouts" ("workout_id");
ALTER TABLE portfolio."workout_sets" ADD CONSTRAINT "fk_workout_sets_1" FOREIGN KEY ("exercise_id") REFERENCES portfolio."exercises" ("exercise_id");
ALTER TABLE portfolio."workouts" ADD CONSTRAINT "workout_status_check" CHECK (("status" = 'in_progress') OR ("status" = 'completed'));
CREATE UNIQUE INDEX "one_active_workout_per_member" ON portfolio."workouts" ("member_id") WHERE ("status" = 'in_progress');
ALTER TABLE portfolio."workout_sets" ADD CONSTRAINT "set_reps_positive" CHECK ("reps" > 0);
ALTER TABLE portfolio."workout_sets" ADD CONSTRAINT "set_load_nonnegative" CHECK ("load_kg" >= 0);
COMMIT;
