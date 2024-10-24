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
        title: Text(widget.hikeId != null ? 'Edit Hike' : 'Add Hike'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title input
                TextFormField(
                  initialValue: title,
                  decoration: InputDecoration(
                    labelText: 'Hike Title',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                const SizedBox(height: 20),

                // Location input
                TextFormField(
                  initialValue: location,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                const SizedBox(height: 20),

                // Description input
                TextFormField(
                  initialValue: description,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSaved: (value) {
                    description = value ?? '';
                  },
                ),
                const SizedBox(height: 20),

                // Parking Available switch
                SwitchListTile(
                  title: const Text('Parking Available'),
                  value: parkingAvailable,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      parkingAvailable = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Length input
                TextFormField(
                  initialValue: length.toString(),
                  decoration: InputDecoration(
                    labelText: 'Length (km)',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                const SizedBox(height: 20),

                // Difficulty dropdown
                DropdownButtonFormField<String>(
                  value: difficulty,
                  decoration: InputDecoration(
                    labelText: 'Difficulty',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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

                // Save button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _saveHike,
                    child: const Text(
                      'Save Hike',
                      style: TextStyle(
                          fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
