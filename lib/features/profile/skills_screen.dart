import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../models/skill.dart';
import 'profile_provider.dart';

class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsAsync = ref.watch(skillsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
      ),
      body: skillsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Error loading skills')),
        data: (skills) {
          if (skills.isEmpty) return const Center(child: Text('No skills found'));

          final technical = skills.where((s) => s.category == SkillCategory.technical).toList();
          final soft = skills.where((s) => s.category == SkillCategory.soft).toList();
          final language = skills.where((s) => s.category == SkillCategory.language).toList();
          final other = skills.where((s) => s.category == SkillCategory.other).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (technical.isNotEmpty) ...[
                  _buildCategoryHeader('Technical Skills'),
                  _buildSkillsGrid(technical),
                  const SizedBox(height: 24),
                ],
                if (soft.isNotEmpty) ...[
                  _buildCategoryHeader('Soft Skills'),
                  _buildSkillsGrid(soft),
                  const SizedBox(height: 24),
                ],
                if (language.isNotEmpty) ...[
                  _buildCategoryHeader('Languages'),
                  _buildSkillsGrid(language),
                  const SizedBox(height: 24),
                ],
                if (other.isNotEmpty) ...[
                  _buildCategoryHeader('Other Skills'),
                  _buildSkillsGrid(other),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.textMain,
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(List<Skill> skills) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: skills.map((skill) => _buildSkillChip(skill)).toList(),
    );
  }

  Widget _buildSkillChip(Skill skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.outline, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              skill.level,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
