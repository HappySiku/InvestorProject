import 'package:flutter/material.dart';

// Define the data model for a hike (optional)
class Hike {
  final String name;
  final String location;
  final String date;
  final bool parkingAvailable;
  final String length;
  final String difficulty;

  Hike({
    required this.name,
    required this.location,
    required this.date,
    required this.parkingAvailable,
    required this.length,
    required this.difficulty,
  });
}

class AddHikeForm extends StatefulWidget {
  @override
  _AddHikeFormState createState() => _AddHikeFormState();
}

class _AddHikeFormState extends State<AddHikeForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _location = "";
  String _date = "";
  bool _parkingAvailable = false;
  String _length = "";
  String _difficulty = "Easy";
  DateTime? _selectedDate;

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _date = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Hike'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Name Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name for the hike.';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => _name = value),
                ),
                const SizedBox(height: 16.0),

                // Location Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location of the hike.';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => _location = value),
                ),
                const SizedBox(height: 16.0),

                // Date Picker Field
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  onTap: () => _selectDate(context),
                  controller: TextEditingController(text: _date),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the date of the hike.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Parking Available Field
                Row(
                  children: [
                    const Text('Parking Available:'),
                    Checkbox(
                      value: _parkingAvailable,
                      onChanged: (value) => setState(() => _parkingAvailable = value!),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Length Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Length (e.g., 5km)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the length of the hike.';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => _length = value),
                ),
                const SizedBox(height: 16.0),

                // Difficulty Dropdown
                DropdownButtonFormField<String>(
                  value: _difficulty,
                  items: const [
                    DropdownMenuItem(
                      value: "Easy",
                      child: Text('Easy'),
                    ),
                    DropdownMenuItem(
                      value: "Moderate",
                      child: Text('Moderate'),
                    ),
                    DropdownMenuItem(
                      value: "Hard",
                      child: Text('Hard'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _difficulty = value!),
                  decoration: InputDecoration(
                    labelText: 'Select Hike Difficulty',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newHike = Hike(
                        name: _name,
                        location: _location,
                        date: _date,
                        parkingAvailable: _parkingAvailable,
                        length: _length,
                        difficulty: _difficulty,
                      );
                      Navigator.pop(context, newHike);
                    }
                  },
                  child: const Text('Save Hike'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
