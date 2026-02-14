import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/assignment.dart';

/// عند تخزين [coordinates] لمناطق تظليل، استخدم نسباً من 0 إلى 1 من أبعاد الصورة
/// (مثلاً left: 0.1 = 10% من اليسار، width: 0.8 = 80% من عرض الصورة)
/// كي يظهر التظليل صحيحاً على كل أحجام الشاشات.

/// جلب مهام الطالب من جدول assignments (الأحدث أولاً).
Future<List<Assignment>> fetchAssignmentsForStudent(String studentId) async {
  final client = Supabase.instance.client;
  final res = await client
      .from('assignments')
      .select()
      .eq('student_id', studentId)
      .order('created_at', ascending: false);
  return (res as List)
      .map((e) => Assignment.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}

/// إدراج مهمة في جدول assignments.
Future<void> insertAssignment({
  required String studentId,
  required String teacherId,
  required String type,
  required int pageNumber,
  Map<String, dynamic>? coordinates,
  String? title,
}) async {
  final client = Supabase.instance.client;
  await client.from('assignments').insert({
    'student_id': studentId,
    'teacher_id': teacherId,
    'type': type,
    'page_number': pageNumber,
    'coordinates': coordinates ?? {'fullPage': true},
    'title': title ?? 'صفحة $pageNumber',
  });
}
