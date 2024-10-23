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
    }
    else {
      // If the username is not available in shared preferences, get it from Firestore
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
        return doc.data() as Map<String, dynamic>; // Correct casting
      }).toList();
    });
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
              'Hike Explorer',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    String? userName = snapshot.data?? 'Explorer';
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
                          onPressed: () {},
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
                            onPressed: () {}, icon: const Icon(Icons.search)),
                      ],
                    ),
                  ),
                ],
              ),
              //add a static image

              SizedBox(height: 10),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getHikes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Failed to load hikes');
                  } else if (snapshot.data!.isEmpty || !snapshot.hasData) {
                    return const Text('No hikes available');
                  } else {
                    final hikes = snapshot.data!;
                    return Column(
                      children: hikes.map((hike) {
                        return TrailReviewItem(
                          title: hike['title'] as String?,
                          location: hike['location'] as String?,
                          date: hike['date'] as Timestamp?,
                          parkingAvailable: hike['parkingAvailable'] as bool?,
                          length: hike['length'],
                          difficulty: hike['difficulty'] as String?,
                          description: hike['description'] as String?,
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

  // Helper methods to get images and data
  String getImageUrl(int index) {
    switch (index) {
      case 0:
        return 'assets/images/splash.png';
      case 1:
        return 'assets/images/splash.png';
      case 2:
        return 'assets/images/splash.png';
      default:
        return 'assets/images/splash.png';
    }
  }

  String getTrailName(int index) {
    switch (index) {
      case 0:
        return 'Alps';
      case 1:
        return 'Everest';
      case 2:
        return 'Lukenya';
      default:
        return 'Mount Kenya';
    }
  }

  String getTrailDifficulty(int index) {
    switch (index) {
      case 0:
        return 'Moderate';
      case 1:
        return 'Hard';
      case 2:
        return 'Easy';
      default:
        return 'Moderate';
    }
  }
}

class TrailReviewItem extends StatelessWidget {
  final String? title; // Name of the hike
  final String? location; // Location of the hike
  final Timestamp? date; // Date of the hike
  final bool? parkingAvailable; // Parking available (Yes or No)
  final dynamic length; // Length of the hike
  final String? difficulty; // Level of difficulty
  final String? description; // Optional description

  const TrailReviewItem({
    Key? key,
    this.title,
    this.location,
    this.date,
    this.parkingAvailable,
    this.length,
    this.difficulty,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: ${location ?? 'Unknown'}'),
                Text(
                    'Date: ${date != null ? DateFormat.yMMMd().format(date!.toDate()) : 'Unknown'}'),
                Text(
                    'Parking Available: ${parkingAvailable != null && parkingAvailable! ? 'Yes' : 'No'}'),
                Text('Length: ${length != null ? ('${length}m') : 'Unknown'}'),
                Text('Difficulty: ${difficulty ?? 'Unknown'}'),
                if (description != null && description!.isNotEmpty)
                  Text('Description: $description'),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
