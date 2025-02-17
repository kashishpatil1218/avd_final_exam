import 'package:avd_final_exam/Modal/student_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore{
  FireStore._();

  static FireStore fireStore = FireStore._();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addInFireBase(StudentModal todo) async {
    await firebaseFirestore
        .collection("user")
        .doc(todo.id.toString())
        .set(StudentModal.toMap(todo));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getData() {
    return firebaseFirestore.collection("user").snapshots();
  }
}