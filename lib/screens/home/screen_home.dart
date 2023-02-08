import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_5/db/provider/provider.dart';

import 'package:week_5/screens/home/widgets/add_student_widget.dart';
import 'package:week_5/screens/home/widgets/list_student_widget.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //provider
    final studentProvider = Provider.of<ProviderData>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      studentProvider.getAllStudents();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Home Screen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ProviderData value, Widget? child) => Column(
            children: [
              CupertinoSearchTextField(
                  padding: const EdgeInsets.all(20),
                  borderRadius: BorderRadius.circular(10),
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.grey.shade100,
                  controller: searchController,
                  onChanged: (value) {
                    Provider.of<ProviderData>(context, listen: false)
                        .runFilter(value);
                  }),
              Expanded(child: ListStudentWidget()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 3, 61, 131),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentWidget(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
