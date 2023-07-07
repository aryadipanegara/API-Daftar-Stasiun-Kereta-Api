import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Station {
  final String code;
  final String name;
  final String city;
  final String cityName;

  Station({
    required this.code,
    required this.name,
    required this.city,
    required this.cityName,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      code: json['code'],
      name: json['name'],
      city: json['city'],
      cityName: json['cityname'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Stasiun Kereta Api',
      theme: ThemeData(
        primaryColor: Color(0xFF002171),
        accentColor: Color(0xFFF7941D),
        fontFamily: 'Roboto',
      ),
      home: StasiunKeretaApiPage(),
    );
  }
}

class StasiunKeretaApiPage extends StatefulWidget {
  @override
  _StasiunKeretaApiPageState createState() => _StasiunKeretaApiPageState();
}

class _StasiunKeretaApiPageState extends State<StasiunKeretaApiPage> {
  List<Station> stations = [];
  List<Station> filteredStations = [];
  int currentNumber = 1;

  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  Future<void> fetchStations() async {
    final response =
        await http.get(Uri.parse('https://booking.kai.id/api/stations2'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      stations = data.map((station) => Station.fromJson(station)).toList();
      filteredStations = List.from(stations);
      setState(() {});
    }
  }

  void filterStations(String query) {
    filteredStations = stations.where((station) {
      return station.name.toLowerCase().contains(query.toLowerCase()) ||
          station.city.toLowerCase().contains(query.toLowerCase()) ||
          station.cityName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      currentNumber = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/kai_logo.png',
                width: 24,
                height: 24,
              ),
            ),
            Text(
              'Daftar Stasiun Kereta Api',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF002171),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => filterStations(value),
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStations.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      '${currentNumber++}. ${filteredStations[index].name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      '${filteredStations[index].city}, ${filteredStations[index].cityName}',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
