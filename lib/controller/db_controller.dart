import 'package:avd_final_exam/Modal/student_modal.dart';
import 'package:avd_final_exam/server/sql/db_helper.dart';
import 'package:get/get.dart';

var dbController = Get.put(DbController());

class DbController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    DbHelper.dbHelper.database;
    readAllData();
  }

  RxList<StudentModal> dataList = <StudentModal>[].obs;

  Future<void> addData({required String name,
    required String attendance,
    required String date}) async {
    await DbHelper.dbHelper.InsertData(name, attendance, date);
    readAllData();
  }

  Future<void> readAllData() async {
    List<Map> data = await DbHelper.dbHelper.readData();
    dataList.value = data
        .map(
          (e) => StudentModal.fromMap(e),
    )
        .toList();
  }

  Future<void> deletData(int id) async {
    await DbHelper.dbHelper.deletData(id);
    readAllData();
  }

  Future<void> updateData({required String nameValue,
    required String attendanceValue,
    required int idValue}) async {
    StudentModal todo = StudentModal(id: idValue,
        name: nameValue,
        date: DateTime.now().toIso8601String(),
        attendance: attendanceValue);

    await DbHelper.dbHelper.updateData(todo);
    readAllData();
  }

}
