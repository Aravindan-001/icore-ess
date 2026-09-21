enum SkillCategory { technical, soft, language, other }

class Skill {
  final String name;
  final String level; // e.g., Beginner, Intermediate, Expert
  final SkillCategory category;

  Skill({
    required this.name,
    required this.level,
    required this.category,
  });
}
