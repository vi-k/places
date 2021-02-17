import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_history.dart';
import 'package:places/main.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/failed.dart';
import 'package:places/ui/widget/loader.dart';
import 'package:places/ui/widget/place_small_card.dart';
import 'package:places/ui/widget/search_bar.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/svg_button.dart';

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

    return Loader<List<Place>?>(
      load: () async => lastQuery.length < 2
          ? null
          : await placeInteractor.searchPlaces(lastQuery),
      error: (context, error) => Failed(
        message: error.toString(),
        onRepeat: () => Loader.of<List<Place>?>(context).reload(),
      ),
      builder: (context, state, places) => Scaffold(
        appBar: SmallAppBar(
          title: stringPlaceList,
          bottom: Padding(
            padding: commonPadding,
            child: SearchBar(
              initialText: initialText,
              onTextChanged: (text) {
                if (lastQuery != text) {
                  lastQuery = text;
                  Loader.of<List<Place>?>(context).reload();
                }
              },
            ),
          ),
        ),
        body: places == null
            ? _buildHistory(theme)
            : places.isEmpty
                ? const Failed(
                    svg: Svg64.search,
                    title: stringNothingFound,
                    message: stringNothingFoundMessage,
                  )
                : _buildResults(places),
      ),
    );
  }

  Widget _buildHistory(MyThemeData theme) => Loader<List<SearchHistory>>(
        load: placeInteractor.getSearchHistory,
        error: (context, error) => Failed(
          message: error.toString(),
          onRepeat: () => Loader.of<List<Place>?>(context).reload(),
        ),
        builder: (context, state, searchList) => searchList == null ||
                searchList.isEmpty
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
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        final searchInfo = searchList[index];
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
                          trailing: SvgButton(
                            Svg24.delete,
                            color: theme.textRegular14Light.color,
                            onPressed: () async {
                              await placeInteractor
                                  .removeFromSearchHistory(searchInfo.text);
                              Loader.of<List<SearchHistory>>(context).reload();
                            },
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const Padding(
                        padding: commonPaddingLR,
                        child: Divider(height: dividerHeight),
                      ),
                    ),
                  ),
                  SmallButton(
                    label: stringClearHistory,
                    style: theme.textMiddle16Accent,
                    onPressed: () async {
                      await placeInteractor.clearSearchHistory();
                      Loader.of<List<SearchHistory>>(context).reload();
                    },
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
