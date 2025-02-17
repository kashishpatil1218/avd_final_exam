class StudentModal {
  String? name, attendance, date;
  int? id;

  StudentModal({
    this.id,
     required this.date,
    required this.name,
    required this.attendance,
  });

  factory StudentModal.fromMap(Map m1) {
    return StudentModal(
      id: m1['id'],
      name: m1['name'],
      date: m1['date'],
      attendance: m1['attendance'],
    );
  }

  static Map<String, Object?> toMap(StudentModal studentModal) {
    return {
      'id': studentModal.id,
      'name': studentModal.name,
      'attendance': studentModal.attendance,
      'date': studentModal.date,
    };
  }
}
