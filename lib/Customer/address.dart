import 'package:flutter/material.dart';
import 'package:trashtrack/api_address.dart';

class DropDownExample extends StatefulWidget {
  @override
  _DropDownExampleState createState() => _DropDownExampleState();
}

class _DropDownExampleState extends State<DropDownExample> {
  List<dynamic> _provinces = [];
  List<dynamic> _citiesMunicipalities = [];
  List<dynamic> _barangays = [];

  String? _selectedProvince;
  String? _selectedCityMunicipality;
  String? _selectedBarangay = 'haahaha';

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    try {
      final provinces = await fetchProvinces();
      setState(() {
        _provinces = provinces;
      });
    } catch (e) {
      print('Error fetching provinces: $e');
    }
  }

  Future<void> _loadCitiesMunicipalities(String provinceCode) async {
    try {
      final citiesMunicipalities = await fetchCitiesMunicipalities(provinceCode);
      setState(() {
        _citiesMunicipalities = citiesMunicipalities;
        _barangays = []; // Clear barangays when a new city is selected
        _selectedCityMunicipality = null;
        _selectedBarangay = null;
      });
    } catch (e) {
      print('Error fetching cities/municipalities: $e');
    }
  }

  Future<void> _loadBarangays(String cityMunicipalityCode) async {
    try {
      final barangays = await fetchBarangays(cityMunicipalityCode);
      setState(() {
        _barangays = barangays;
        _selectedBarangay = null;
      });
    } catch (e) {
      print('Error fetching barangays: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cebu Location Dropdowns'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedProvince,
              hint: Text('Select Province'),
              items: _provinces.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['code'], // Province code
                  child: Text(item['name']), // Province name
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProvince = value;
                });
                _loadCitiesMunicipalities(value!);
              },
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedCityMunicipality,
              hint: Text('Select City/Municipality'),
              items: _citiesMunicipalities.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['code'], // City/Municipality code
                  child: Text(item['name']), // City/Municipality name
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCityMunicipality = value;
                });
                _loadBarangays(value!);
              },
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedBarangay,
              hint: Text('Select Barangay'),
              items: _barangays.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['code'], // Barangay code
                  child: Text(item['name']), // Barangay name
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBarangay = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

