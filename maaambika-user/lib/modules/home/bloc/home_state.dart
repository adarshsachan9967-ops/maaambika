abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> banners;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> refurbished;

  const HomeLoaded({
    required this.banners,
    required this.categories,
    required this.refurbished,
  });
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
