import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<String> _getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fullName') ?? '';
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
            icon: const Icon(Icons.account_circle, color: Colors.black),
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
              FutureBuilder<String>(
                future: _getUserName(),
                builder: (context, snapshot) {

                  if(snapshot.connectionState==ConnectionState.waiting) {
                    return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                    return const Text('Welcome, Explorer!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    );
                  } else {
                    return Text('Welcome, ${snapshot.data}!',
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
              const TrailReviewItem(
                title: 'Himalayas',
                description: 'Breath-taking views and challenging terrains.',
                location: 'Nepal',
                date: '2022-12-12',
                parkingAvailable: true,
                length: '10km',
                difficulty: 'Hard',
                weatherForecast: 'Sunny',
                wildlife: 'Mountain goats',
              ),
              const TrailReviewItem(
                title: 'Mount Kenya',
                description:
                    'An amazing experience, must for adventure lovers!',
                location: 'Kenya',
                date: '2022-12-12',
                parkingAvailable: true,
                length: '15km',
                difficulty: 'Moderate',
                weatherForecast: 'Sunny',
                wildlife: 'Elephants',
              ),
              const TrailReviewItem(
                title: 'Mount Everest',
                description: 'The ultimate hike for thrill-seekers.',
                location: 'Nepal',
                date: '2022-12-12',
                parkingAvailable: true,
                length: '20km',
                difficulty: 'Hard',
                weatherForecast: 'Sunny',
                wildlife: 'Snow leopards',
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
  final String title; // Name of the hike
  final String location; // Location of the hike
  final String date; // Date of the hike
  final bool parkingAvailable; // Parking available (Yes or No)
  final String length; // Length of the hike
  final String difficulty; // Level of difficulty
  final String? description; // Optional description
  final String? weatherForecast; // Weather forecast - custom field
  final String? wildlife;// Wildlife sightings - custom field

  const TrailReviewItem({
    Key? key,
    required this.title,
    required this.location,
    required this.date,
    required this.parkingAvailable,
    required this.length,
    required this.difficulty,
    this.description,
    this.weatherForecast,
    this.wildlife,

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
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: $location'),
                Text('Date: $date'),
                Text('Parking Available: ${parkingAvailable ? 'Yes' : 'No'}'),
                Text('Length: $length'),
                Text('Difficulty: $difficulty'),
                if (description != null && description!.isNotEmpty)
                  Text('Description: $description'),
                if (weatherForecast != null && weatherForecast!.isNotEmpty)
                  Text('Weather Forecast: $weatherForecast'),
                if (wildlife != null && wildlife!.isNotEmpty)
                  Text('Wildlife Sightings: $wildlife'),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

