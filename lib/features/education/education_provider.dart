import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/education_declaration.dart';

final educationDeclarationsProvider = FutureProvider<List<EducationDeclaration>>((ref) async {
  final service = ref.watch(educationServiceProvider);
  return service.getEducationDeclarations();
});

final educationDetailProvider = FutureProvider.family<EducationDeclaration, String>((ref, id) async {
  final service = ref.watch(educationServiceProvider);
  return service.getEducationDeclarationDetail(id);
});
