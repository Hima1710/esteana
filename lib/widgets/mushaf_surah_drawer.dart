import 'package:flutter/material.dart';

import '../models/mushaf_surah.dart';
import '../theme/app_theme.dart';

/// ألوان تصميم «إستعانة» — أوف وايت مع لمسات ذهبية وخضراء هادئة.
class _IstianaColors {
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color gold = Color(0xFFB8860B);
  static const Color goldLight = Color(0xFFE8D5A3);
  static const Color green = Color(0xFF2E7D6E);
  static const Color greenLight = Color(0xFFE0F2F1);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color border = Color(0xFFE8E4DE);
}

/// قائمة جانبية تفتح من اليمين: فهرس السور الـ 114 مع رقم صفحة مصحف المدينة + شريط بحث.
class MushafSurahDrawer extends StatefulWidget {
  const MushafSurahDrawer({
    super.key,
    required this.surahs,
    required this.isArabic,
    required this.searchHint,
    required this.onSurahSelected,
  });

  final List<MushafSurah> surahs;
  final bool isArabic;
  final String searchHint;
  final void Function(int pageNumber) onSurahSelected;

  @override
  State<MushafSurahDrawer> createState() => _MushafSurahDrawerState();
}

class _MushafSurahDrawerState extends State<MushafSurahDrawer> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<MushafSurah> get _filtered {
    if (_query.trim().isEmpty) return widget.surahs;
    final q = _query.trim().toLowerCase();
    return widget.surahs.where((s) {
      final nameAr = s.nameAr.toLowerCase();
      final nameEn = s.nameEn.toLowerCase();
      return nameAr.contains(q) || nameEn.contains(q) || s.surahNumber.toString() == q;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.85,
      backgroundColor: _IstianaColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildSearchBar(context),
            const Divider(height: 1, color: _IstianaColors.border),
            Expanded(
              child: _filtered.isEmpty
                  ? _buildEmpty(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final s = _filtered[index];
                        return _SurahTile(
                          surah: s,
                          isArabic: widget.isArabic,
                          onTap: () {
                            widget.onSurahSelected(s.startPage);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: BoxDecoration(
        color: _IstianaColors.surface,
        border: Border(
          bottom: BorderSide(color: _IstianaColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _IstianaColors.greenLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: _IstianaColors.green,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'فهرس السور',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _IstianaColors.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: widget.searchHint,
          hintStyle: TextStyle(color: _IstianaColors.textSecondary, fontSize: 15),
          prefixIcon: Icon(Icons.search_rounded, color: _IstianaColors.gold, size: 22),
          filled: true,
          fillColor: _IstianaColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kShapeRadius),
            borderSide: const BorderSide(color: _IstianaColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kShapeRadius),
            borderSide: const BorderSide(color: _IstianaColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kShapeRadius),
            borderSide: const BorderSide(color: _IstianaColors.gold, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(color: _IstianaColors.textPrimary, fontSize: 16),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: _IstianaColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              'لا توجد نتائج',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _IstianaColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  const _SurahTile({
    required this.surah,
    required this.isArabic,
    required this.onTap,
  });

  final MushafSurah surah;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = isArabic ? surah.nameAr : surah.nameEn;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: _IstianaColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _IstianaColors.border, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _IstianaColors.goldLight.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${surah.surahNumber}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _IstianaColors.gold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _IstianaColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _IstianaColors.greenLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ص ${surah.startPage}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _IstianaColors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
