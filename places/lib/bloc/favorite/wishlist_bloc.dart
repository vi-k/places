part of 'favorite_bloc.dart';

class WishlistBloc extends _FavoriteBloc {
  WishlistBloc(PlaceInteractor placeInteractor) : super._(placeInteractor);

  @override
  Future<List<Place>> _getList() => _placeInteractor.getWishlist();

  @override
  Future<Place> _removeFromList(Place place) =>
      _placeInteractor.removeFromWishlist(place);

  @override
  Future<Place> _addToAdjacentList(Place place) =>
      _placeInteractor.addToVisited(place);

  @override
  bool _isOwn(Place place) => place.userInfo.favorite == Favorite.wishlist;
}
