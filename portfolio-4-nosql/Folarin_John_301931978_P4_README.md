# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection training_events for workout_started and set_recorded events. These are fictional event examples based on members, workouts, workout_sets, exercises.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related exercises details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "workout_started",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "workout_sets",
        "key": {
            "set_id": 401
        },
        "snapshot": {
            "set_id": 401,
            "workout_id": 301,
            "exercise_id": 201,
            "set_number": 1,
            "reps": 8,
            "load_kg": 40
        }
    },
    "embedded": {
        "exercises": [
            {
                "key": {
                    "exercise_id": 201
                },
                "snapshot": {
                    "exercise_id": 201,
                    "name": "Squat",
                    "category": "strength",
                    "is_bodyweight": false
                },
                "via": [
                    "workout_sets.exercise_id → exercises"
                ]
            }
        ]
    },
    "references": {
        "members": [
            {
                "key": {
                    "member_id": 101
                },
                "via": [
                    "workout_sets.workout_id → workouts.member_id → members"
                ]
            }
        ],
        "workouts": [
            {
                "key": {
                    "workout_id": 301
                },
                "via": [
                    "workout_sets.workout_id → workouts"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("training_events").find({"eventType":"workout_started"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "workout_started",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "set_id": 401
    }
  },
  {
    "_id": "event_000003",
    "eventType": "workout_started",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "set_id": 402
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("training_events").find({"source.key.set_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "workout_started",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "set_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "set_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "set_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("training_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "workout_started",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "set_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "set_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "set_id": 401
    }
  },
  {
    "_id": "event_000003",
    "eventType": "workout_started",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "set_id": 402
    }
  },
  {
    "_id": "event_000004",
    "eventType": "set_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "set_id": 402
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("training_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| set_recorded | 2 |
| workout_started | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Folarin_John_301931978_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Folarin_John_301931978_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

