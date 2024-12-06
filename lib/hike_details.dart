import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'add_observation.dart';

class HikeDetailsPage extends StatelessWidget {
  static const String routeName = '/hike_details';

  const HikeDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments from the route settings
    final Map<String, dynamic>? arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      // Handle the case where arguments are null
      return const Scaffold(
        body: Center(
          child: Text('No hike details provided'),
        ),
      );
    }

    // Extracting hike details from arguments with null safety
    final String hikeId = arguments['hikeId'] as String? ?? 'Unknown ID';
    final String title = arguments['title'] as String? ?? 'Unknown';
    final String location = arguments['location'] as String? ?? 'Unknown';
    final Timestamp? date = arguments['date'] as Timestamp?;
    final bool? parkingAvailable = arguments['parkingAvailable'] as bool?;
    final dynamic length = arguments['length'];
    final String? difficulty = arguments['difficulty'] as String? ?? 'Unknown';
    final String? description = arguments['description'] as String?;
    final double? latitude = arguments['latitude'] as double?;
    final double? longitude = arguments['longitude'] as double?;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Google Map section
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      latitude ?? -1.286389, // Default to Nairobi if latitude is null
                      longitude ?? 36.817223, // Default to Nairobi if longitude is null
                    ),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('location_marker'),
                      position: LatLng(
                        latitude ?? -1.286389,
                        longitude ?? 36.817223,
                      ),
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationEnabled: false,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Hike title
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Location and Date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(
                  Icons.location_on,
                  location,
                  Colors.green,
                ),
                _iconText(
                  Icons.calendar_today,
                  date != null
                      ? DateFormat.yMMMd().format(date.toDate())
                      : 'Unknown',
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Parking availability
            _detailCard(
              'Parking Available',
              parkingAvailable != null && parkingAvailable ? 'Yes' : 'No',
              Icons.local_parking,
              Colors.orange,
            ),

            // Length of the hike
            const SizedBox(height: 10),
            _detailCard(
              'Hike Length',
              length != null ? '${length} meters' : 'Unknown',
              Icons.straighten,
              Colors.teal,
            ),

            // Difficulty level
            const SizedBox(height: 10),
            _detailCard(
              'Difficulty Level',
              difficulty ?? 'Unknown',
              Icons.terrain,
              Colors.redAccent,
            ),

            // Description
            const SizedBox(height: 20),
            if (description != null && description.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddObservationPage(hikeId: hikeId),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Helper widget to display details with an icon and text
  Widget _iconText(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Helper widget for displaying detail cards with an icon, title, and value
  Widget _detailCard(
      String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import 'add_observation.dart';
//
// class HikeDetailsPage extends StatelessWidget {
//   static const String routeName = '/hike_details';
//
//   const HikeDetailsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Retrieve the arguments from the route settings
//     final Map<String, dynamic>? arguments =
//     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//
//     if (arguments == null) {
//       // Handle the case where arguments are null
//       return const Scaffold(
//         body: Center(
//           child: Text('No hike details provided'),
//         ),
//       );
//     }
//
//     // Extracting hike details from arguments with null safety
//     final String hikeId = arguments['hikeId'] as String? ?? 'Unknown ID'; // Provide a default value
//     final String title = arguments['title'] as String? ?? 'Unknown';
//     final String location = arguments['location'] as String? ?? 'Unknown';
//     final Timestamp? date = arguments['date'] as Timestamp?;
//     final bool? parkingAvailable = arguments['parkingAvailable'] as bool?;
//     final dynamic length = arguments['length'];
//     final String? difficulty = arguments['difficulty'] as String? ?? 'Unknown';
//     final String? description = arguments['description'] as String?;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hike image placeholder (you can replace with actual images)
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 image: const DecorationImage(
//                   image: NetworkImage(
//                       'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Mount_Kenya.jpg/800px-Mount_Kenya.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Hike title
//             Center(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // Location and Date row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _iconText(
//                   Icons.location_on,
//                   location,
//                   Colors.green,
//                 ),
//                 _iconText(
//                   Icons.calendar_today,
//                   date != null
//                       ? DateFormat.yMMMd().format(date.toDate())
//                       : 'Unknown',
//                   Colors.blue,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//
//             // Parking availability
//             _detailCard(
//               'Parking Available',
//               parkingAvailable != null && parkingAvailable ? 'Yes' : 'No',
//               Icons.local_parking,
//               Colors.orange,
//             ),
//
//             // Length of the hike
//             const SizedBox(height: 10),
//             _detailCard(
//               'Hike Length',
//               length != null ? '${length} meters' : 'Unknown',
//               Icons.straighten,
//               Colors.teal,
//             ),
//
//             // Difficulty level
//             const SizedBox(height: 10),
//             _detailCard(
//               'Difficulty Level',
//               difficulty ?? 'Unknown', // Use null-aware operator
//               Icons.terrain,
//               Colors.redAccent,
//             ),
//
//             // Description
//             const SizedBox(height: 20),
//             if (description != null && description.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Description',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       description,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddObservationPage(hikeId: hikeId),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   // Helper widget to display details with an icon and text
//   Widget _iconText(IconData icon, String text, Color iconColor) {
//     return Row(
//       children: [
//         Icon(icon, color: iconColor),
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: const TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }
//
//   // Helper widget for displaying detail cards with an icon, title, and value
//   Widget _detailCard(
//       String title, String value, IconData icon, Color iconColor) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 6,
//             offset: const Offset(0, 2), // changes position of shadow
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: iconColor, size: 30),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }