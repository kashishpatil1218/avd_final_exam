import 'package:avd_final_exam/Modal/student_modal.dart';
import 'package:avd_final_exam/controller/db_controller.dart';
import 'package:avd_final_exam/controller/student_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../server/fireStore/fire_store_servic.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Student Erp',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              for (int i = 0; i < dbController.dataList.length; i++) {
                StudentModal todo = StudentModal(
                  name: dbController.dataList[i].name,
                  attendance: dbController.dataList[i].attendance,
                  date: dbController.dataList[i].date,
                );
                await FireStore.fireStore.addInFireBase(todo);
              }
            },
            icon: Icon(
              Icons.cloud,
              color: Colors.white,
            ),
          ),
          StreamBuilder(
              stream: FireStore.fireStore.getData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List data = snapshot.data!.docs;
                  List<StudentModal> userList = data
                      .map(
                        (e) => StudentModal.fromMap(e.data()),
                      )
                      .toList();
                  return IconButton(
                    onPressed: () async {
                      for (int i = 0; i < dbController.dataList.length; i++) {
                        await dbController
                            .deletData(dbController.dataList[i].id!);
                      }

                      for (int i = 0; i <= userList.length; i++) {
                        await dbController.addData(
                          name: userList[i].name.toString(),
                          attendance: userList[i].attendance.toString(),
                          date: userList[i].date.toString(),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.backup,
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error_outline);
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
        // title: const Text("app"),
      ),
      body: Obx(
        () => ListView.builder(
            itemCount: dbController.dataList.length,
            itemBuilder: (BuildContext context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    color: Colors.blue.shade200,
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await dbController
                                  .deletData(dbController.dataList[index].id!);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog<void>(
                                  context: context,

                                  // false = user must tap button, true = tap outside dialog
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text('Update'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              color: Colors.grey.shade300,
                                              child: TextField(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Student Name'),
                                                  controller:
                                                      authController.txtName),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.grey.shade300,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'precent/absent'),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      ),
                                                  controller: authController
                                                      .txtAttendace),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Update'),
                                          onPressed: () {
                                            dbController.updateData(
                                                nameValue:
                                                    authController.txtName.text,
                                                attendanceValue: authController
                                                    .txtAttendace.text,
                                                idValue: dbController
                                                    .dataList[index].id!
                                                    .toInt());
                                            Navigator.of(dialogContext)
                                                .pop(); // Dismiss alert dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.edit))
                        ],
                      ),
                      title: Text(dbController.dataList[index].name.toString()),
                      subtitle: Text(
                          dbController.dataList[index].attendance.toString()),
                    )),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Add'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'stduent name',
                            border: InputBorder.none,
                          ),
                          controller: authController.txtName,
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'present/ upsent',
                            border: InputBorder.none,
                          ),
                          controller: authController.txtAttendace,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Add'),
                    onPressed: () async {
                      await dbController.addData(
                          name: authController.txtName.text,
                          attendance: authController.txtAttendace.text,
                          date: DateTime.now().toString());
                      Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
