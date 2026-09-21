import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/airfare.dart';

final airfareDeclarationsProvider = FutureProvider<List<AirfareDeclaration>>((ref) async {
  final service = ref.watch(airfareServiceProvider);
  return service.getAirfareDeclarations();
});

final airfareDetailProvider = FutureProvider.family<AirfareDeclaration, String>((ref, id) async {
  final service = ref.watch(airfareServiceProvider);
  return service.getAirfareDeclarationDetail(id);
});
