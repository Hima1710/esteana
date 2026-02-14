/// نموذج مهمة من جدول assignments.
class Assignment {
  const Assignment({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.type,
    required this.pageNumber,
    this.coordinates,
    this.title,
    required this.createdAt,
  });

  final String id;
  final String studentId;
  final String teacherId;
  final String type;
  final int pageNumber;
  final Map<String, dynamic>? coordinates;
  final String? title;
  final DateTime createdAt;

  factory Assignment.fromJson(Map<String, dynamic> json) {
    final createdAt = json['created_at'];
    return Assignment(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      teacherId: json['teacher_id'] as String,
      type: json['type'] as String,
      pageNumber: (json['page_number'] as num).toInt(),
      coordinates: json['coordinates'] != null
          ? Map<String, dynamic>.from(json['coordinates'] as Map)
          : null,
      title: json['title'] as String?,
      createdAt: createdAt is DateTime
          ? createdAt
          : DateTime.parse(createdAt as String),
    );
  }
}
