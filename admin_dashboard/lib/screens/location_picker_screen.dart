import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;

  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialAddress,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _addressController = TextEditingController();
  
  bool _isLoadingCurrentLocation = false;
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _latitudeController.text = widget.initialLatitude!.toString();
      _longitudeController.text = widget.initialLongitude!.toString();
      _addressController.text = widget.initialAddress ?? '';
    }
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingCurrentLocation = true;
    });

    try {
      // التحقق من الأذونات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog('تم رفض إذن الموقع');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog('تم رفض إذن الموقع نهائياً. يرجى تفعيله من الإعدادات');
        return;
      }

      // الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitudeController.text = position.latitude.toStringAsFixed(6);
        _longitudeController.text = position.longitude.toStringAsFixed(6);
      });

      // الحصول على العنوان
      await _getAddressFromCoordinates(position.latitude, position.longitude);

    } catch (e) {
      _showErrorDialog('خطأ في الحصول على الموقع: $e');
    } finally {
      setState(() {
        _isLoadingCurrentLocation = false;
      });
    }
  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    setState(() {
      _isLoadingAddress = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '${place.street ?? ''} ${place.locality ?? ''} ${place.administrativeArea ?? ''} ${place.country ?? ''}';
        setState(() {
          _addressController.text = address.trim();
        });
      }
    } catch (e) {
      setState(() {
        _addressController.text = 'لا يمكن تحديد العنوان';
      });
    } finally {
      setState(() {
        _isLoadingAddress = false;
      });
    }
  }

  Future<void> _getCoordinatesFromAddress() async {
    if (_addressController.text.trim().isEmpty) {
      _showErrorDialog('يرجى إدخال العنوان أولاً');
      return;
    }

    setState(() {
      _isLoadingAddress = true;
    });

    try {
      List<Location> locations = await locationFromAddress(_addressController.text.trim());
      if (locations.isNotEmpty) {
        Location location = locations.first;
        setState(() {
          _latitudeController.text = location.latitude.toStringAsFixed(6);
          _longitudeController.text = location.longitude.toStringAsFixed(6);
        });
      }
    } catch (e) {
      _showErrorDialog('لا يمكن العثور على العنوان');
    } finally {
      setState(() {
        _isLoadingAddress = false;
      });
    }
  }

  void _confirmSelection() {
    if (_latitudeController.text.trim().isEmpty || _longitudeController.text.trim().isEmpty) {
      _showErrorDialog('يرجى إدخال الإحداثيات أو العنوان');
      return;
    }

    try {
      double lat = double.parse(_latitudeController.text.trim());
      double lng = double.parse(_longitudeController.text.trim());
      
      Navigator.pop(context, {
        'latitude': lat,
        'longitude': lng,
        'address': _addressController.text.trim(),
      });
    } catch (e) {
      _showErrorDialog('الإحداثيات غير صحيحة');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار موقع المدرسة'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _confirmSelection,
            child: const Text(
              'تأكيد',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الموقع الحالي
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الموقع الحالي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoadingCurrentLocation ? null : _getCurrentLocation,
                        icon: _isLoadingCurrentLocation
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(_isLoadingCurrentLocation ? 'جاري الحصول على الموقع...' : 'استخدام الموقع الحالي'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // بطاقة الإحداثيات
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الإحداثيات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _latitudeController,
                            decoration: const InputDecoration(
                              labelText: 'خط العرض (Latitude)',
                              prefixIcon: Icon(Icons.navigation),
                              border: OutlineInputBorder(),
                              hintText: '24.7136',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _longitudeController,
                            decoration: const InputDecoration(
                              labelText: 'خط الطول (Longitude)',
                              prefixIcon: Icon(Icons.navigation),
                              border: OutlineInputBorder(),
                              hintText: '46.6753',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isLoadingAddress ? null : () {
                          if (_latitudeController.text.trim().isNotEmpty && 
                              _longitudeController.text.trim().isNotEmpty) {
                            double lat = double.parse(_latitudeController.text.trim());
                            double lng = double.parse(_longitudeController.text.trim());
                            _getAddressFromCoordinates(lat, lng);
                          }
                        },
                        icon: _isLoadingAddress
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.search),
                        label: Text(_isLoadingAddress ? 'جاري البحث...' : 'الحصول على العنوان'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // بطاقة العنوان
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'العنوان',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'عنوان المدرسة',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                        hintText: 'شارع الملك فهد، الرياض، المملكة العربية السعودية',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isLoadingAddress ? null : _getCoordinatesFromAddress,
                        icon: _isLoadingAddress
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.search),
                        label: Text(_isLoadingAddress ? 'جاري البحث...' : 'الحصول على الإحداثيات'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // معلومات إضافية
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'معلومات مفيدة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• يمكنك استخدام الموقع الحالي للحصول على إحداثياتك الحالية\n'
                      '• أو إدخال الإحداثيات يدوياً إذا كنت تعرفها\n'
                      '• أو إدخال العنوان للحصول على الإحداثيات تلقائياً\n'
                      '• تأكد من صحة الإحداثيات قبل التأكيد',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
