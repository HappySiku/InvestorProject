import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddHikeForm extends StatefulWidget {
  final String? hikeId; // Optional hike ID for editing
  final String? title;
  final String? location;
  final String? description;
  final Timestamp? date;
  final bool parkingAvailable;
  final dynamic length;
  final String? difficulty;

  const AddHikeForm({
    Key? key,
    this.hikeId,
    this.title,
    this.location,
    this.description,
    this.date,
    this.parkingAvailable = false,
    this.length = 0.0,
    this.difficulty,
  }) : super(key: key);

  @override
  _AddHikeFormState createState() => _AddHikeFormState();
}

class _AddHikeFormState extends State<AddHikeForm> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String location;
  late String description;
  late bool parkingAvailable;
  late dynamic length;
  late String difficulty;
  late Timestamp date;

  @override
  void initState() {
    super.initState();
    // Initialize fields with existing hike data if editing
    title = widget.title ?? '';
    location = widget.location ?? '';
    description = widget.description ?? '';
    parkingAvailable = widget.parkingAvailable;
    length = widget.length ?? 0.0;
    difficulty = widget.difficulty ?? 'Easy';
    date = widget.date ?? Timestamp.now();
  }

  Future<void> _saveHike() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final hikesCollection = FirebaseFirestore.instance.collection('hikes');

      if (widget.hikeId != null) {
        // Update existing hike
        await hikesCollection.doc(widget.hikeId).update({
          'title': title,
          'location': location,
          'description': description,
          'date': date,
          'parkingAvailable': parkingAvailable,
          'length': length,
          'difficulty': difficulty,
        });
      } else {
        // Add new hike
        await hikesCollection.add({
          'title': title,
          'location': location,
          'description': description,
          'date': date,
          'parkingAvailable': parkingAvailable,
          'length': length,
          'difficulty': difficulty,
        });
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveHike,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Hike Title'),
                onSaved: (value) {
                  title = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: location,
                decoration: const InputDecoration(labelText: 'Location'),
                onSaved: (value) {
                  location = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  description = value ?? '';
                },
              ),
              SwitchListTile(
                title: const Text('Parking Available'),
                value: parkingAvailable,
                onChanged: (value) {
                  setState(() {
                    parkingAvailable = value;
                  });
                },
              ),
              TextFormField(
                initialValue: length.toString(),
                decoration: const InputDecoration(labelText: 'Length (m)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  length = double.tryParse(value ?? '0') ?? 0.0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a length';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: difficulty,
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: <String>['Easy', 'Moderate', 'Hard']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    difficulty = value ?? 'Easy';
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveHike,
                child: const Text('Save Hike'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
