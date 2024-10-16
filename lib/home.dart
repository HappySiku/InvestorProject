import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
            icon: const Icon(Icons.map, color: Colors.black),
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
              const Text(
                'Welcome, Explorer!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
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
                          'Let\'s get you started.',
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

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Welcome',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       '',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           '',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(width: 10),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                           ),
//                           onPressed: () {},
//                           child: const Text('Go',
//                               style: TextStyle(
//                                 color: Colors.green,
//                               )),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Most Visited',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         'See All',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                       SizedBox(width: 5),
//                       Icon(
//                         Icons.arrow_forward,
//                         color: Colors.red,
//                         size: 16,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               // add a carousel
//               CarouselSlider.builder(
//                 itemCount: 3,
//                 itemBuilder: (context, index, realIndex) {
//                   switch (index) {
//                     case 0:
//                       return PlanCard(
//                         color: Colors.green,
//                         title: 'Alps',
//                         returnPercentage: '',
//                       );
//                     case 1:
//                       return const PlanCard(
//                         color: Colors.green,
//                         title: 'Everest',
//                         returnPercentage: '',
//                       );
//                     case 2:
//                       return const PlanCard(
//                         color: Colors.green,
//                         title: 'Lukenya',
//                         returnPercentage: '',
//                       );
//                     default:
//                       return const PlanCard(
//                         color: Colors.green,
//                         title: 'M. Kenya',
//                         returnPercentage: '',
//                       );
//                   }
//                 },
//                 options: CarouselOptions(
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   enableInfiniteScroll: true,
//                   viewportFraction: 0.3,
//                 ),
//               ),
//
//               SizedBox(height: 20),
//               const Text(
//                 'Route Reviews',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               const InvestmentGuideItem(
//                 title: 'Himalayas',
//                 description: 'Great views',
//               ),
//               const InvestmentGuideItem(
//                 title: 'Mount Kenya',
//                 description: 'Lovely adventure',
//               ),
//               const InvestmentGuideItem(
//                 title: 'Mount Everest',
//                 description: 'Explore the highest peak',
//               ),
//               const InvestmentGuideItem(
//                 title: 'Lukenya',
//                 description: 'Connect with nature',
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.map_sharp),
//             label: 'Routes',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Account',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class PlanCard extends StatelessWidget {
//   final Color color;
//   final String title;
//   final String returnPercentage;
//
//   const PlanCard({
//     Key? key,
//     required this.color,
//     required this.title,
//     required this.returnPercentage,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//                 color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Text(
//             returnPercentage,
//             style: TextStyle(color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class InvestmentGuideItem extends StatelessWidget {
//   final String title;
//   final String description;
//
//   const InvestmentGuideItem({
//     Key? key,
//     required this.title,
//     required this.description,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           contentPadding: EdgeInsets.zero,
//           trailing: const CircleAvatar(
//             backgroundColor: Colors.blue,
//             child: Icon(Icons.book, color: Colors.white),
//           ),
//           title: Text(
//             title,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(description),
//         ),
//         Divider(),
//       ],
//     );
//   }
// }
