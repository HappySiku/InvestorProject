import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Used to build the database path

class AddObservationPage extends StatefulWidget {
  final String hikeId;  // Hike ID to associate the observation with

  const AddObservationPage({Key? key, required this.hikeId}) : super(key: key);

  @override
  _AddObservationPageState createState() => _AddObservationPageState();
}

class _AddObservationPageState extends State<AddObservationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _observation;
  DateTime _selectedTime = DateTime.now();
  String? _comments;

  // SQLite database reference
  Database? _db;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'hike_observations.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE observations(id INTEGER PRIMARY KEY, hikeId TEXT, observation TEXT, time TEXT, comments TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _addObservation() async {
    if (_db != null && _formKey.currentState!.validate()) {
      await _db!.insert(
        'observations',
        {
          'hikeId': widget.hikeId,
          'observation': _observation,
          'time': _selectedTime.toIso8601String(),
          'comments': _comments ?? '',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // After saving, pop the page and go back
     Navigator.pop(context as BuildContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Observation"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Observation field (required)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Observation *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an observation';
                  }
                  return null;
                },
                onSaved: (value) {
                  _observation = value;
                },
              ),
              const SizedBox(height: 20),

              // Time of observation (pre-filled with current time)
              Row(
                children: [
                  const Text('Time of Observation: ', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat.yMMMd().add_jm().format(_selectedTime),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedTime = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Additional comments (optional)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Additional Comments'),
                onSaved: (value) {
                  _comments = value;
                },
              ),
              const SizedBox(height: 30),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _addObservation();
                    }
                  },
                  child: const Text('Save Observation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
