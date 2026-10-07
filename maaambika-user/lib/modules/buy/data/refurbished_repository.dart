import '../../../core/services/api_service.dart';
import '../../../data/fallback/fallback_data.dart';

class RefurbishedRepository {
  Future<List<Map<String, dynamic>>> fetchRefurbishedProducts() async {
    return ApiService.cachedRefurbished.isNotEmpty
        ? ApiService.cachedRefurbished
        : FallbackData.refurbished;
  }
}
