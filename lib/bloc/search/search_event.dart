part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType()';
}

class SearchStarted extends SearchEvent {
  const SearchStarted([this.text = '']);

  final String text;

  @override
  List<Object?> get props => [text];

  @override
  String toString() => 'SearchStarted($text)';
}

class SearchHistoryCleared extends SearchEvent {
  const SearchHistoryCleared();
}

class SearchRemovedFromHistory extends SearchEvent {
  const SearchRemovedFromHistory(this.text);

  final String text;

  @override
  List<Object?> get props => [text];

  @override
  String toString() => 'SearchRemovedFromHistory($text)';
}

class SearchPlaceChanged extends SearchEvent {
  const SearchPlaceChanged(this.notification) : super();

  final PlaceNotification notification;

  @override
  List<Object?> get props => [notification];

  @override
  String toString() => 'SearchPlaceChanged($notification)';
}
