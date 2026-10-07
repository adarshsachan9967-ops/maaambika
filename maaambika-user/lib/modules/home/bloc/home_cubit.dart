import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/catalog_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final CatalogRepository _repository;

  HomeCubit({CatalogRepository? repository})
      : _repository = repository ?? CatalogRepository(),
        super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(const HomeLoading());
    try {
      final banners = await _repository.fetchBanners();
      final categories = await _repository.fetchCategories();
      final refurbished = await _repository.fetchRefurbished();

      emit(HomeLoaded(
        banners: banners,
        categories: categories,
        refurbished: refurbished,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
