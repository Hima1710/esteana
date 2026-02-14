import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../generated/l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/my_study_tasks_widget.dart';

/// شاشة «مهامي الدراسية»: فهرس واجبات الطالب.
class MyAssignmentsScreen extends StatelessWidget {
  const MyAssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.myStudyTasks)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.loginRequired,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.myStudyTasks),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.gradientFor(Theme.of(context).brightness),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            MyStudyTasksWidget(studentId: userId, l10n: l10n),
          ],
        ),
      ),
    );
  }
}
