import '../../../core/services/api_service.dart';
import '../../../data/fallback/fallback_data.dart';

class CatalogRepository {
  Future<List<Map<String, dynamic>>> fetchBanners() async {
    return ApiService.cachedBanners.isNotEmpty ? ApiService.cachedBanners : FallbackData.banners;
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    return ApiService.cachedCategories.isNotEmpty ? ApiService.cachedCategories : FallbackData.categories;
  }

  Future<List<Map<String, dynamic>>> fetchRefurbished() async {
    return ApiService.cachedRefurbished.isNotEmpty ? ApiService.cachedRefurbished : FallbackData.refurbished;
  }
}
