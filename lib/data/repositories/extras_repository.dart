import '../models/extras_model.dart';
import '../providers/extras_api_provider.dart';

class ExtraRepository {
  final ExtraApiProvider apiProvider;

  ExtraRepository({required this.apiProvider});

  Future<List<Extra>> fetchExtras(int foodId) async {
    return await apiProvider.fetchExtras(foodId);
  }
}
