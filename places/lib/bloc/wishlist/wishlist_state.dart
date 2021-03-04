part of 'wishlist_bloc.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

/// Начальное состояние.
///
/// Нигде не используется. Нужно для того, чтобы не забывать отправлять первое
/// событие.
class WishlistInitial extends WishlistState {}

/// Состояние: загрузка данных.
class WishlistLoading extends WishlistState {}

/// Состояние: данные загружены.
class WishlistLoaded extends WishlistState {
  const WishlistLoaded(this.places);

  final List<Place> places;

  @override
  List<Object> get props => [places];
}
