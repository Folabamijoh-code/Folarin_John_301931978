# Fitness and Workout Tracking — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| workout_id | workout_sets records (list) |
| --- | --- |
| 301 | [401] |
| 302 | [402] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| workout_sets.set_id | workout_sets.workout_id | workout_sets.exercise_id | workouts.workout_id | workouts.member_id | workouts.status | members.member_id | members.display_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | 201 | 301 | 101 | in_progress | 101 | Avery Chen |
| 402 | 302 | 202 | 302 | 102 | completed | 102 | Jordan Patel |

Key: set_id.

## 2NF: depend on the whole key

workout_sets: workout_id is a proper part of candidate key (workout_id, exercise_id, set_number), and determines workouts details. workout_sets: exercise_id is a proper part of candidate key (workout_id, exercise_id, set_number), and determines exercises details.

## workouts_example

| workouts.workout_id | workouts.member_id | workouts.status | members.member_id | members.display_name |
| --- | --- | --- | --- | --- |
| 301 | 101 | in_progress | 101 | Avery Chen |
| 302 | 102 | completed | 102 | Jordan Patel |

## workout_sets_example

| workout_sets.set_id | workout_sets.workout_id | workout_sets.exercise_id |
| --- | --- | --- |
| 401 | 301 | 201 |
| 402 | 302 | 202 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## members

| member_id | display_name | email | joined_on |
| --- | --- | --- | --- |
| 101 | Avery Chen | avery.chen@example.test | 2025-01-15 |
| 102 | Jordan Patel | jordan.patel@example.test | 2025-02-20 |

## exercises

| exercise_id | name | category | is_bodyweight |
| --- | --- | --- | --- |
| 201 | Squat | strength | false |
| 202 | Push-up | bodyweight | true |

## workouts

| workout_id | member_id | started_at | ended_at | status |
| --- | --- | --- | --- | --- |
| 301 | 101 | 2025-03-01T09:00:00+00:00 | NULL | in_progress |
| 302 | 102 | 2025-03-02T10:00:00+00:00 | 2025-03-02T10:45:00+00:00 | completed |

## workout_sets

| set_id | workout_id | exercise_id | set_number | reps | load_kg |
| --- | --- | --- | --- | --- | --- |
| 401 | 301 | 201 | 1 | 8 | 40 |
| 402 | 302 | 202 | 1 | 12 | 0 |

## Dependencies

- members: (member_id) → display_name, email, joined_on
- exercises: (exercise_id) → name, category, is_bodyweight
- workouts: (workout_id) → member_id, started_at, ended_at, status
- workout_sets: (set_id) → workout_id, exercise_id, set_number, reps, load_kg

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
