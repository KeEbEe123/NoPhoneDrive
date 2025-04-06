import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MissedCallsScreen extends StatefulWidget {
  @override
  _MissedCallsScreenState createState() => _MissedCallsScreenState();
}

class _MissedCallsScreenState extends State<MissedCallsScreen> {
  List missedCalls = [];

  @override
  void initState() {
    super.initState();
    fetchMissedCalls();
  }

  Future<void> fetchMissedCalls() async {
    final response = await http.get(
      Uri.parse('https://your-backend.com/api/missed-calls'),
    );
    if (response.statusCode == 200) {
      setState(() {
        missedCalls = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Missed Calls & Messages')),
      body: ListView.builder(
        itemCount: missedCalls.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              missedCalls[index]['name'] ?? missedCalls[index]['number'],
            ),
            subtitle: Text(
              DateTime.fromMillisecondsSinceEpoch(
                missedCalls[index]['timestamp'],
              ).toString(),
            ),
          );
        },
      ),
    );
  }
}
