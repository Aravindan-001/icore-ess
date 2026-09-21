import '../models/education_declaration.dart';
import '../repositories/education_repository.dart';

class EducationService {
  final EducationRepository _educationRepo;

  EducationService(this._educationRepo);

  Future<List<EducationDeclaration>> getEducationDeclarations() => _educationRepo.getEducationDeclarations();
  
  Future<EducationDeclaration> getEducationDeclarationDetail(String id) => 
      _educationRepo.getEducationDeclarationDetail(id);
}
