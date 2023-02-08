import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:week_5/db/provider/provider.dart';
import 'package:week_5/screens/home/widgets/student_details.dart';

class ListStudentWidget extends StatelessWidget {
  const ListStudentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderData>(
      builder: (BuildContext ctx, value, Widget? child) {
        if (value.foundUsers.isNotEmpty) {
          return ListView.separated(
            itemBuilder: (ctx, index) {
              final data = value.foundUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: FileImage(
                    File(data.photo),
                  ),
                ),
                title: Text(data.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Age:${data.age}'),
                    // Text('Phone:${data.mobile}'),
                    // Text(data.school),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    ProviderData.deleteItem(context, data.id.toString());
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetails(
                        name: data.name,
                        age: data.age,
                        mobile: data.mobile,
                        school: data.school,
                        index: index,
                        photo: data.photo,
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (ctx, index) {
              return const Divider();
            },
            itemCount: value.foundUsers.length,
          );
        } else {
          return const Center(
            child: Text('Add some Students'),
          );
        }
      },
    );
  }
}
