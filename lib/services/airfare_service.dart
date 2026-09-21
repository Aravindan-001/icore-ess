import '../models/airfare.dart';
import '../repositories/airfare_repository.dart';

class AirfareService {
  final AirfareRepository _airfareRepo;

  AirfareService(this._airfareRepo);

  Future<List<AirfareDeclaration>> getAirfareDeclarations() => _airfareRepo.getAirfareDeclarations();
  
  Future<AirfareDeclaration> getAirfareDeclarationDetail(String id) => 
      _airfareRepo.getAirfareDeclarationDetail(id);
}
