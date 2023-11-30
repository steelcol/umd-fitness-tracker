import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class InteractiveMapPage extends StatefulWidget {
  InteractiveMapPage({Key? key, required this.updateLocation}) : super(key: key);

  final Function updateLocation;

  @override
  InteractiveMapPageState createState() => InteractiveMapPageState();
}

class InteractiveMapPageState extends State<InteractiveMapPage> {
  double longitude = 0;
  double latitude = 0;

  final controller = MapController(
    location: const LatLng(46.78, -92.11),
  );

  void _gotoDefault() {
    controller.center = const LatLng(46.78, -92.11);
    setState(() {});
  }

  Future<void> _showLocationDialog(
      BuildContext context, double latitude, double longitude) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have clicked on:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Latitude: $latitude\nLongitude: $longitude',
            ),
            SizedBox(height: 16),
            Center( // Wrap the ElevatedButton with Center widget
              child: ElevatedButton(
                onPressed: () {
                  _getCoords(latitude, longitude);
                  widget.updateLocation(latitude, longitude);
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Enter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDoubleTap(MapTransformer transformer, Offset position) {
    const delta = 2.5;
    final zoom = _clamp(controller.zoom + delta, 2, 18);
    transformer.setZoomInPlace(zoom, position);
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;

  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(
      ScaleUpdateDetails details, MapTransformer transformer) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      transformer.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  void _getCoords(double x, double y) {
    latitude = x;
    longitude = y;
  }

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Map'),
      ),
      body: MapLayout(
        controller: controller,
        builder: (context, transformer) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTapDown: (details) => _onDoubleTap(
              transformer,
              details.localPosition,
            ),
            onScaleStart: _onScaleStart,
            onScaleUpdate: (details) => _onScaleUpdate(details, transformer),
            onTapUp: (details) {
              final location =
              transformer.toLatLng(details.localPosition);
              _showLocationDialog(
                  context, location.latitude, location.longitude);
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta.dy / -1000.0;
                  final zoom = _clamp(controller.zoom + delta, 2, 18);
                  transformer.setZoomInPlace(zoom, event.localPosition);
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  TileLayer(
                    builder: (context, x, y, z) {
                      final tilesInZoom = pow(2.0, z).floor();

                      while (x < 0) {
                        x += tilesInZoom;
                      }
                      while (y < 0) {
                        y += tilesInZoom;
                      }

                      x %= tilesInZoom;
                      y %= tilesInZoom;

                      return CachedNetworkImage(
                        imageUrl: _google(z, x, y),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }

  String _google(int z, int x, int y) {
    return 'https://mt1.google.com/vt/x=$x&y=$y&z=$z';
  }
}
