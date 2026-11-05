# Fitness and Workout Tracking — database design

My case study records members, exercises, workouts, workout_sets.

## Users

- Members tracking their workouts
- Coaches reviewing member training history

## Main operations

- Create and complete workout sessions
- Record exercise sets with repetitions and load
- Review workout history and training totals

## Entities

| Entity | Information stored |
| --- | --- |
| members | Stores member identity and join date. |
| exercises | Stores exercise names and categories referenced by recorded workout sets. |
| workouts | Stores a member's workout session and links it to its owner. |
| workout_sets | Stores an exercise set in a workout, including its set number, repetitions, and kilogram load. |

## members

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| member_id | BIGINT | PK | Yes |
| display_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| joined_on | DATE |  | Yes |
- Unique key: (email).

## exercises

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| exercise_id | BIGINT | PK | Yes |
| name | TEXT | Unique | Yes |
| category | TEXT |  | Yes |
| is_bodyweight | BOOLEAN |  | Yes |
- Unique key: (name).

## workouts

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| workout_id | BIGINT | PK | Yes |
| member_id | BIGINT | FK | Yes |
| started_at | TIMESTAMPTZ |  | Yes |
| ended_at | TIMESTAMPTZ |  | No |
| status | TEXT |  | Yes |
- member_id → members.member_id

## workout_sets

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| set_id | BIGINT | PK | Yes |
| workout_id | BIGINT | FK | Yes |
| exercise_id | BIGINT | FK | Yes |
| set_number | INTEGER |  | Yes |
| reps | INTEGER |  | Yes |
| load_kg | NUMERIC(18,2) |  | Yes |
- workout_id → workouts.workout_id
- exercise_id → exercises.exercise_id
- Unique key: (workout_id, exercise_id, set_number).

## Relationships and business rules

- Each member email identifies at most one member.
- Each exercise name identifies at most one exercise definition.
- Every workout belongs to an existing member.
- A workout status must be in_progress or completed.
- At most one workout per member may have status in_progress; enforce with a partial unique constraint on member_id for in-progress workouts.
- Every recorded set belongs to an existing workout.
- Every recorded set references an existing exercise definition.
- Each recorded set must have a positive repetition count.
- Each recorded set must have a load of zero kilograms or greater.
- Within a workout and exercise, each set number is unique.

## Assumptions

- All timestamps are stored in UTC; a workout may have no end time while it is in progress.
- A member may have at most one in-progress workout at a time; completed workouts remain in the history.
- A workout set has a positive set number and repetition count. Load is measured in kilograms, with zero representing a bodyweight set.
- Repeated exercises in a workout are represented by distinct set numbers for that exercise.
- IDs are globally unique across all four entity tables.
- Normalization example: begin with a workouts row containing workout_id, member_id, member_name, email, started_at, ended_at, and status. Since member_id determines member_name and email, move those member attributes to members and retain member_id in workouts; workout_id determines the remaining workout attributes.

