import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});
  static String id = 'AddDoctorPage';
  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _governorateController = TextEditingController();
  final _regionController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _contactController = TextEditingController();
  final _clinicNameController = TextEditingController();
  final _workingHoursController = TextEditingController();
  final _bioController = TextEditingController();
  final _ratingController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _governorateController.dispose();
    _regionController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _specialtyController.dispose();
    _contactController.dispose();
    _clinicNameController.dispose();
    _workingHoursController.dispose();
    _bioController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _addDoctor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final doctorData = {
          'name': _nameController.text.trim(),
          'image': _imageController.text.trim(),
          'governorate': _governorateController.text.trim(),
          'region': _regionController.text.trim(),
          'latitude': double.parse(_latController.text.trim()),
          'longitude': double.parse(_lngController.text.trim()),
          'specialty': _specialtyController.text.trim(),
          'contact': _contactController.text.trim(),
          'clinicName': _clinicNameController.text.trim(),
          'workingHours': _workingHoursController.text.trim(),
          'bio': _bioController.text.trim(),
          'rating': double.parse(_ratingController.text.trim()),
        };

        await FirebaseFirestore.instance
            .collection('dermatologists')
            .add(doctorData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Doctor added successfully!')),
          );
          Navigator.pop(context); // Return to previous page
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error adding doctor: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          'Add New Doctor',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.08,
          ),
          colors: const [Color(0xff12748B), Color(0xff051F25)],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Name', _nameController, 'Please enter a name'),
                _buildTextField(
                  'Image URL',
                  _imageController,
                  'Please enter an image URL',
                ),
                _buildTextField(
                  'Governorate',
                  _governorateController,
                  'Please enter a governorate',
                ),
                _buildTextField(
                  'Region',
                  _regionController,
                  'Please enter a region',
                ),
                _buildTextField(
                  'Latitude',
                  _latController,
                  'Please enter a latitude',
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 'latitude'),
                ),
                _buildTextField(
                  'Longitude',
                  _lngController,
                  'Please enter a longitude',
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 'longitude'),
                ),
                _buildTextField(
                  'Specialty',
                  _specialtyController,
                  'Please enter a specialty',
                ),
                _buildTextField(
                  'Contact',
                  _contactController,
                  'Please enter contact info',
                ),
                _buildTextField(
                  'Clinic Name',
                  _clinicNameController,
                  'Please enter a clinic name',
                ),
                _buildTextField(
                  'Working Hours',
                  _workingHoursController,
                  'Please enter working hours',
                ),
                _buildTextField(
                  'Bio',
                  _bioController,
                  'Please enter a bio',
                  maxLines: 3,
                ),
                _buildTextField(
                  'Rating',
                  _ratingController,
                  'Please enter a rating (0-5)',
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateRating(value),
                ),
                const SizedBox(height: 24),

                ElevatedButton(onPressed: () {}, child: Text('run code')),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff12748B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _isLoading ? null : _addDoctor,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              'Add Doctor',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String validationMessage, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return validationMessage;
              }
              return null;
            },
      ),
    );
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $fieldName';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number for $fieldName';
    }
    return null;
  }

  String? _validateRating(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a rating';
    }
    final rating = double.tryParse(value);
    if (rating == null) {
      return 'Please enter a valid number for rating';
    }
    if (rating < 0 || rating > 5) {
      return 'Rating must be between 0 and 5';
    }
    return null;
  }
}
