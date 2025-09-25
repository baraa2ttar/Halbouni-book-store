import 'package:adv/core/exports/main_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveMapWidget extends StatefulWidget {
  const LiveMapWidget({super.key});

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> {
  GoogleMapController? mapController;

  static const LatLng fallbackLocation = LatLng(36.2021, 37.1343); // موقع ثابت

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: 335,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: fallbackLocation,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: {
          const Marker(
            markerId: MarkerId("fixed_location"),
            position: fallbackLocation,
            infoWindow: InfoWindow(title: "موقع ثابت"),
          )
        },
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }
}
