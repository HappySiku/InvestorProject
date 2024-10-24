import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SearchHikesPage extends StatefulWidget {
  const SearchHikesPage({Key? key}) : super(key: key);

  @override
  _SearchHikesPageState createState() => _SearchHikesPageState();
}

class _SearchHikesPageState extends State<SearchHikesPage> {
  String _searchQuery = '';
  String _location = '';
  String _length = '';
  DateTime? _date;
  bool _isAdvancedSearchVisible = false;

  final TextEditingController _searchController = TextEditingController();

  Stream<List<Map<String, dynamic>>> _searchHikes() {
    Query query = FirebaseFirestore.instance.collection('hikes');

    // Basic search by name with prefix matching
    if (_searchQuery.isNotEmpty) {
      query = query.where('title', isGreaterThanOrEqualTo: _searchQuery)
          .where('title', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
    }

    // Advanced search options
    if (_location.isNotEmpty) {
      query = query.where('location', isEqualTo: _location);
    }

    if (_length.isNotEmpty) {
      query = query.where('length', isEqualTo: _length);
    }

    if (_date != null) {
      final Timestamp timestamp = Timestamp.fromDate(_date!);
      query = query.where('date', isEqualTo: timestamp);
    }

    return query.snapshots().map((querySnapshot) => querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Search Hikes', style: TextStyle(color: Colors.green)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
            const SizedBox(height: 20),

            // Advanced Search Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isAdvancedSearchVisible = !_isAdvancedSearchVisible;
                    });
                  },
                  icon: Icon(
                    _isAdvancedSearchVisible
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.green,
                  ),
                  label: const Text('Advanced Search',
                      style: TextStyle(color: Colors.green)),
                ),
              ],
            ),

            // Advanced Search Fields (Collapsible)
            if (_isAdvancedSearchVisible)
              Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Location',
                      prefixIcon: Icon(Icons.location_on, color: Colors.green),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _location = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Length',
                      prefixIcon: Icon(Icons.timeline, color: Colors.green),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _length = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.date_range, color: Colors.white),
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _date = selectedDate;
                        });
                      }
                    },
                    label: Text(
                      _date == null
                          ? 'Select Date'
                          : DateFormat('MMM dd, yyyy').format(_date!),
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Search Results
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _searchHikes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Failed to load hikes');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No hikes found');
                  } else {
                    final hikes = snapshot.data!;
                    return ListView.builder(
                      itemCount: hikes.length,
                      itemBuilder: (context, index) {
                        final hike = hikes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              hike['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.green, size: 18),
                                    const SizedBox(width: 4),
                                    Text(hike['location']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.date_range,
                                        color: Colors.green, size: 18),
                                    const SizedBox(width: 4),
                                    Text(DateFormat('MMM dd, yyyy').format(
                                        (hike['date'] as Timestamp).toDate())),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/hike_details',
                                  arguments: hike);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
