import '../models/airfare.dart';

abstract class AirfareRepository {
  Future<List<AirfareDeclaration>> getAirfareDeclarations();
  Future<AirfareDeclaration> getAirfareDeclarationDetail(String id);
}
