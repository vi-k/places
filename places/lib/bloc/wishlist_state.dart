part of 'wishlist_bloc.dart';

/// Состояния для WishlistBloc.
@immutable
abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
///
/// Нигде не используется. Нужно для того, чтобы не забывать отправлять первое
/// событие.
class WishlistInitial extends WishlistState {}

/// Состояние: загрузка данных.
class WishlistLoading extends WishlistState {}

/// Состояние: данные загружены.
class WishlistReady extends WishlistState {
  const WishlistReady(this.places);

  final List<Place> places;

  @override
  List<Object?> get props => [places];
}
