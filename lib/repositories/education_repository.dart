import '../models/education_declaration.dart';

abstract class EducationRepository {
  Future<List<EducationDeclaration>> getEducationDeclarations();
  Future<EducationDeclaration> getEducationDeclarationDetail(String id);
}
