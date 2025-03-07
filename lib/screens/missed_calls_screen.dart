import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MissedCallsScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Missed Calls')),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getMissedCalls('user-id'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No missed calls');
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final call = snapshot.data![index];
              return ListTile(
                title: Text(call['caller']),
                subtitle: Text(call['time']),
              );
            },
          );
        },
      ),
    );
  }
}
