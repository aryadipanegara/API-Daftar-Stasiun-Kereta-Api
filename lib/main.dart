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

  Station(
      {required this.code,
      required this.name,
      required this.city,
      required this.cityName});

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
      title: 'KAI Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Station> stations = [];
  List<Station> filteredStations = [];

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KAI Booking'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => filterStations(value),
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStations.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(filteredStations[index].name),
                    subtitle: Text(
                        '${filteredStations[index].city}, ${filteredStations[index].cityName}'),
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
