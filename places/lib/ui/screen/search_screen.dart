import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_history.dart';
import 'package:places/redux/action/search_action.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:places/redux/state/search_state.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/failed.dart';
import 'package:places/ui/widget/place_small_card.dart';
import 'package:places/ui/widget/search_bar.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/svg_button.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:redux/redux.dart';

/// Экран поиска.
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String initialText = '';
  String lastQuery = '';
  final DateFormat _formatter = DateFormat.yMd().add_Hm();

  static final _placeCardPadding = commonPaddingLR.copyWith(
      left: commonSpacing + photoCardSize + commonSpacing);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: SmallAppBar(
        title: stringPlaceList,
        bottom: Padding(
          padding: commonPadding,
          child: StoreConnector<AppState, Store>(
            converter: (store) => store,
            builder: (context, store) => SearchBar(
              initialText: initialText,
              onTextChanged: (text) {
                if (lastQuery != text) {
                  lastQuery = text;
                  store.dispatch(text.isEmpty
                      ? const SearchLoadHistoryAction()
                      : SearchStartAction(text));
                }
              },
            ),
          ),
        ),
      ),
      body: StoreConnector<AppState, SearchState>(
        onInit: (store) => store.dispatch(const SearchLoadHistoryAction()),
        converter: (store) => store.state.searchState,
        builder: (context, state) => state is SearchHistoryState
            ? _buildHistory(theme, state)
            : state is SearchLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state is SearchResultState
                    ? state.places.isEmpty
                        ? const Failed(
                            svg: Svg64.search,
                            title: stringNothingFound,
                            message: stringNothingFoundMessage,
                          )
                        : _buildResults(state.places)
                    : throw ArgumentError(),
      ),
    );
  }

  Widget _buildHistory(MyThemeData theme, SearchHistoryState state) =>
      StoreConnector<AppState, List<SearchHistory>>(
        converter: (store) => state.history,
        builder: (context, history) => history.isEmpty
            ? const Failed(
                svg: Svg64.search,
                title: stringDoFind,
                message: stringDoFindMessage,
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Section(
                    stringLookingFor,
                    child: const SizedBox(),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final searchInfo = history[index];
                        return ListTile(
                          title: Text(
                            searchInfo.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textRegular16Light,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Было найдено: ${searchInfo.count}',
                                style: theme.textRegular12Light56,
                                textAlign: TextAlign.end,
                              ),
                              Text(
                                _formatter.format(searchInfo.timestamp),
                                style: theme.textRegular12Light56,
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              initialText = searchInfo.text;
                            });
                          },
                          trailing: StoreBuilder<AppState>(
                              builder: (context, store) => SvgButton(
                                    Svg24.delete,
                                    color: theme.textRegular14Light.color,
                                    onPressed: () {
                                      store.dispatch(
                                          SearchRemoveFromHistoryAction(
                                              searchInfo.text));
                                    },
                                  )),
                        );
                      },
                      separatorBuilder: (_, __) => const Padding(
                        padding: commonPaddingLR,
                        child: Divider(height: dividerHeight),
                      ),
                    ),
                  ),
                  StoreBuilder<AppState>(
                    builder: (context, store) => SmallButton(
                      label: stringClearHistory,
                      style: theme.textMiddle16Accent,
                      onPressed: () {
                        store.dispatch(const SearchClearHistoryAction());
                      },
                    ),
                  ),
                ],
              ),
      );

  Widget _buildResults(List<Place> places) => ListView.separated(
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return PlaceSmallCard(
            key: ValueKey(place.id),
            place: place,
          );
        },
        separatorBuilder: (_, __) => Padding(
          padding: _placeCardPadding,
          child: const Divider(height: dividerHeight),
        ),
      );
}
