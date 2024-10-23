import 'add_hike.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<String?> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('fullName');

    if (userName != null && userName.isNotEmpty) {
      return userName;
    } else {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc('uid')
          .get();

      if (user.exists) {
        userName = user.get('fullName') as String?;
        prefs.setString('fullName', userName!);
        return userName;
      }
    }
    return null;
  }

  Stream<List<Map<String, dynamic>>> _getHikes() {
    final CollectionReference hikesCollection =
    FirebaseFirestore.instance.collection('hikes');

    return hikesCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Add document ID for reference
          ...doc.data() as Map<String, dynamic>, // Correct casting
        };
      }).toList();
    });
  }

  Future<void> _deleteHike(String hikeId) async {
    await FirebaseFirestore.instance.collection('hikes').doc(hikeId).delete();
  }

  void _confirmDelete(BuildContext context, String hikeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this hike?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteHike(hikeId); // Call the delete function
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Row(
          children: [
            Icon(Icons.terrain, color: Colors.green),
            SizedBox(width: 10),
            Text(
              'M-Hike',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: _getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Welcome, Explorer!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    );
                  } else {
                    String? userName = snapshot.data ?? 'Explorer';
                    return Text(
                      'Welcome, $userName!',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[800]!, Colors.green[400]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Have an upcoming hike?',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Get started.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          onPressed: () async {
                            final newHike = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddHikeForm(),
                              ),
                            );
                            if (newHike != null) {
                              print(newHike);
                            }
                          },
                          child: const Text('Add hike',
                              style: TextStyle(
                                color: Colors.green,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Hikes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getHikes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Failed to load hikes');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No hikes available');
                  } else {
                    final hikes = snapshot.data!;
                    return Column(
                      children: hikes.map((hike) {
                        return TrailReviewItem(
                          id: hike['id'] as String?, // Pass the ID
                          title: hike['title'] as String?,
                          location: hike['location'] as String?,
                          date: hike['date'] as Timestamp?,
                          parkingAvailable: hike['parkingAvailable'] as bool?,
                          length: hike['length'],
                          difficulty: hike['difficulty'] as String?,
                          description: hike['description'] as String?,
                          onDelete: _confirmDelete, // Pass the confirm delete function
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Trails',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class TrailReviewItem extends StatelessWidget {
  final String? id;
  final String? title;
  final String? location;
  final Timestamp? date;
  final bool? parkingAvailable;
  final dynamic length;
  final String? difficulty;
  final String? description;
  final Function(BuildContext, String) onDelete; // Update the type

  const TrailReviewItem({
    Key? key,
    this.id,
    this.title,
    this.location,
    this.date,
    this.parkingAvailable,
    this.length,
    this.difficulty,
    this.description,
    required this.onDelete, // Require the delete function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/hike_details');
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                title ?? 'Unknown',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Location: ${location ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
                  Text('Date: ${date != null ? DateFormat.yMMMd().format(date!.toDate()) : 'Unknown'}', style: TextStyle(fontSize: 16)),
                  Text('Parking Available: ${parkingAvailable != null && parkingAvailable! ? 'Yes' : 'No'}', style: TextStyle(fontSize: 16)),
                  Text('Length: ${length != null ? ('${length}m') : 'Unknown'}', style: TextStyle(fontSize: 16)),
                  Text('Difficulty: ${difficulty ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
                  if (description != null && description!.isNotEmpty)
                    Text('Description: $description', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit Hike Details',
                    style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddHikeForm(
                        hikeId: id,
                        title: title,
                        location: location,
                        description: description,
                        date: date,
                        parkingAvailable: parkingAvailable ?? false,
                        length: length,
                        difficulty: difficulty,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Delete Hike',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  onDelete(context, id!);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
