// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("training_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("training_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "workout_started",
                    "set_recorded"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "workout_sets"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "set_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("training_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "set_recorded",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "workout_sets",
                    "key": {
                        "set_id": 401
                    },
                    "field": "reps",
                    "value": 8
                },
                {
                    "entity": "workout_sets",
                    "key": {
                        "set_id": 401
                    },
                    "field": "load_kg",
                    "value": 40
                }
            ],
            "examples": {
                "note": "illustrative note",
                "device_type": "illustrative device_type"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "workout_started",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "workout_sets",
            "key": {
                "set_id": 402
            },
            "snapshot": {
                "set_id": 402,
                "workout_id": 302,
                "exercise_id": 202,
                "set_number": 1,
                "reps": 12,
                "load_kg": 0
            }
        },
        "embedded": {
            "exercises": [
                {
                    "key": {
                        "exercise_id": 202
                    },
                    "snapshot": {
                        "exercise_id": 202,
                        "name": "Push-up",
                        "category": "bodyweight",
                        "is_bodyweight": true
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
                        "member_id": 102
                    },
                    "via": [
                        "workout_sets.workout_id → workouts.member_id → members"
                    ]
                }
            ],
            "workouts": [
                {
                    "key": {
                        "workout_id": 302
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "set_recorded",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "workout_sets",
            "key": {
                "set_id": 402
            },
            "snapshot": {
                "set_id": 402,
                "workout_id": 302,
                "exercise_id": 202,
                "set_number": 1,
                "reps": 12,
                "load_kg": 0
            }
        },
        "embedded": {
            "exercises": [
                {
                    "key": {
                        "exercise_id": 202
                    },
                    "snapshot": {
                        "exercise_id": 202,
                        "name": "Push-up",
                        "category": "bodyweight",
                        "is_bodyweight": true
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
                        "member_id": 102
                    },
                    "via": [
                        "workout_sets.workout_id → workouts.member_id → members"
                    ]
                }
            ],
            "workouts": [
                {
                    "key": {
                        "workout_id": 302
                    },
                    "via": [
                        "workout_sets.workout_id → workouts"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "workout_sets",
                    "key": {
                        "set_id": 402
                    },
                    "field": "reps",
                    "value": 12
                },
                {
                    "entity": "workout_sets",
                    "key": {
                        "set_id": 402
                    },
                    "field": "load_kg",
                    "value": 0
                }
            ],
            "examples": {
                "note": "illustrative note",
                "device_type": "illustrative device_type"
            }
        }
    }
]));
  await db.getCollection("training_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("training_events").find({"eventType":"workout_started"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("training_events").find({"source.key.set_id":401}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("training_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("training_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("training_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("training_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("training_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
