import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/app_colors.dart';
import '../widgets/app_header.dart';
import '../services/wallet_service.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  final String deliveryLocation;
  final WalletService walletService;

  const DeliveryTrackingScreen({
    super.key,
    required this.deliveryLocation,
    required this.walletService,
  });

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  
  // Mock delivery person location (moving towards delivery location)
  final LatLng _deliveryPersonLocation = const LatLng(6.6018, 3.3515); // Starting point
  final LatLng _destinationLocation = const LatLng(6.6050, 3.3520); // Delivery location
  
  DeliveryStatus _currentStatus = DeliveryStatus.orderConfirmed;
  int _estimatedMinutes = 15;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _startDeliverySimulation();
  }

  void _initializeMap() {
    // Add delivery person marker
    _markers.add(
      Marker(
        markerId: const MarkerId('delivery_person'),
        position: _deliveryPersonLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'Delivery Person'),
      ),
    );

    // Add destination marker
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: _destinationLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: widget.deliveryLocation),
      ),
    );

    // Add route polyline
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: AppColors.primary,
        width: 4,
        points: [_deliveryPersonLocation, _destinationLocation],
        patterns: [
          PatternItem.dash(20),
          PatternItem.gap(10),
        ],
      ),
    );
  }

  void _startDeliverySimulation() {
    // Simulate delivery progress
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentStatus = DeliveryStatus.pickedUp;
          _estimatedMinutes = 12;
        });
      }
    });

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _currentStatus = DeliveryStatus.inTransit;
          _estimatedMinutes = 8;
          _updateDeliveryPersonLocation();
        });
      }
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _currentStatus = DeliveryStatus.nearby;
          _estimatedMinutes = 3;
          _updateDeliveryPersonLocation();
        });
      }
    });

    Future.delayed(const Duration(seconds: 14), () {
      if (mounted) {
        setState(() {
          _currentStatus = DeliveryStatus.delivered;
          _estimatedMinutes = 0;
          _updateDeliveryPersonLocation();
        });
      }
    });
  }

  void _updateDeliveryPersonLocation() {
    // Simulate movement by updating marker position
    final newLat = _deliveryPersonLocation.latitude + 0.001;
    final newLng = _deliveryPersonLocation.longitude + 0.0005;
    
    setState(() {
      _markers.removeWhere((m) => m.markerId == const MarkerId('delivery_person'));
      _markers.add(
        Marker(
          markerId: const MarkerId('delivery_person'),
          position: LatLng(newLat, newLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'Delivery Person'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              showBackButton: true,
              title: 'Track Delivery',
              walletService: widget.walletService,
            ),
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _deliveryPersonLocation,
                      zoom: 15,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: _buildStatusCard(),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: _buildDeliveryInfoCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(),
                      size: 16,
                      color: _getStatusColor(),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = _getProgressValue();
    
    return Column(
      children: [
        Row(
          children: [
            _buildProgressStep(
              icon: Icons.check_circle,
              isActive: progress >= 1,
              label: 'Confirmed',
            ),
            Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: progress >= 1 ? AppColors.primary : AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            _buildProgressStep(
              icon: Icons.inventory_2,
              isActive: progress >= 2,
              label: 'Picked Up',
            ),
            Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: progress >= 2 ? AppColors.primary : AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            _buildProgressStep(
              icon: Icons.local_shipping,
              isActive: progress >= 3,
              label: 'In Transit',
            ),
            Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: progress >= 3 ? AppColors.primary : AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            _buildProgressStep(
              icon: Icons.location_on,
              isActive: progress >= 4,
              label: 'Delivered',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressStep({
    required IconData icon,
    required bool isActive,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: isActive ? Colors.white : AppColors.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                _estimatedMinutes > 0
                    ? 'Estimated arrival: $_estimatedMinutes mins'
                    : 'Delivered!',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.deliveryLocation,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getProgressValue() {
    switch (_currentStatus) {
      case DeliveryStatus.orderConfirmed:
        return 1;
      case DeliveryStatus.pickedUp:
        return 2;
      case DeliveryStatus.inTransit:
        return 3;
      case DeliveryStatus.nearby:
        return 3.5;
      case DeliveryStatus.delivered:
        return 4;
    }
  }

  String _getStatusText() {
    switch (_currentStatus) {
      case DeliveryStatus.orderConfirmed:
        return 'Order Confirmed';
      case DeliveryStatus.pickedUp:
        return 'Picked Up';
      case DeliveryStatus.inTransit:
        return 'In Transit';
      case DeliveryStatus.nearby:
        return 'Nearby';
      case DeliveryStatus.delivered:
        return 'Delivered';
    }
  }

  IconData _getStatusIcon() {
    switch (_currentStatus) {
      case DeliveryStatus.orderConfirmed:
        return Icons.check_circle;
      case DeliveryStatus.pickedUp:
        return Icons.inventory_2;
      case DeliveryStatus.inTransit:
        return Icons.local_shipping;
      case DeliveryStatus.nearby:
        return Icons.near_me;
      case DeliveryStatus.delivered:
        return Icons.done_all;
    }
  }

  Color _getStatusColor() {
    switch (_currentStatus) {
      case DeliveryStatus.orderConfirmed:
        return AppColors.primary;
      case DeliveryStatus.pickedUp:
        return AppColors.primary;
      case DeliveryStatus.inTransit:
        return AppColors.brandGreen;
      case DeliveryStatus.nearby:
        return Colors.orange;
      case DeliveryStatus.delivered:
        return AppColors.brandGreen;
    }
  }
}

enum DeliveryStatus {
  orderConfirmed,
  pickedUp,
  inTransit,
  nearby,
  delivered,
}