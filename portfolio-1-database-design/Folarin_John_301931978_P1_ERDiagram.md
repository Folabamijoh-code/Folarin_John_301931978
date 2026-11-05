# Fitness and Workout Tracking — ER diagram

```mermaid
erDiagram
    direction LR
    members {
        bigint member_id PK
        text display_name
        text email UK
        date joined_on
    }
    exercises {
        bigint exercise_id PK
        text name UK
        text category
        boolean is_bodyweight
    }
    workouts {
        bigint workout_id PK
        bigint member_id FK
        timestamptz started_at
        timestamptz ended_at "Optional"
        text status
    }
    workout_sets {
        bigint set_id PK
        bigint workout_id FK
        bigint exercise_id FK
        integer set_number
        integer reps
        numeric load_kg
    }
    members ||--o{ workouts : "member_id"
    workouts ||--o{ workout_sets : "workout_id"
    exercises ||--o{ workout_sets : "exercise_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Folarin_John_301931978_ERDiagram.png)
