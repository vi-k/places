import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/bloc/search/search_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/widget/failed.dart';
import 'package:places/ui/widget/place_small_card.dart';
import 'package:places/ui/widget/search_bar.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/svg_button.dart';

/// Экран поиска.
class SearchScreen extends StatefulWidget {
  const SearchScreen._({
    Key? key,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();

  /// Помещаем блок выше экрана, чтобы из контекста стейта сразу можно было
  /// обращаться к блоку.
  static void start(BuildContext context) {
    standartNavigatorPush<void>(
        context,
        () => BlocProvider<SearchBloc>(
            create: (_) => SearchBloc(context.read<PlaceInteractor>())
              ..add(const SearchStarted()),
            child: const SearchScreen._()));
  }
}

class _SearchScreenState extends State<SearchScreen> {
  String initialText = '';
  String lastQuery = '';
  final DateFormat _formatter = DateFormat.yMd().add_Hm();

  static final _placeCardPadding = commonPaddingLR.copyWith(
      left: commonSpacing + photoCardSize + commonSpacing);

  SearchBloc get bloc => context.read<SearchBloc>();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SmallAppBar(
        title: stringPlaceList,
        bottom: Padding(
          padding: commonPadding,
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) => SearchBar(
              initialText: initialText,
              onTextChanged: (text) {
                if (lastQuery != text) {
                  lastQuery = text;
                  context.read<SearchBloc>().add(SearchStarted(text));
                }
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchFailure) {
            return Failed(
              svg: Svg64.delete,
              title: stringError,
              message: state.error.toString(),
              onRepeat: () => bloc.add(SearchStarted(state.text)),
            );
          }

          if (state is SearchHistory) {
            return _buildHistory(context, theme, state);
          }

          if (state is SearchSuccess) {
            if (state.places.isEmpty) {
              return const Failed(
                svg: Svg64.search,
                title: stringNothingFound,
                message: stringNothingFoundMessage,
              );
            } else {
              return _buildResults(state.places);
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildHistory(
          BuildContext context, MyThemeData theme, SearchHistory state) =>
      state.history.isEmpty
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
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      final searchInfo = state.history[index];
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
                          onPressed: () {
                            context
                                .read<SearchBloc>()
                                .add(SearchRemovedFromHistory(searchInfo.text));
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
                  onPressed: () {
                    context.read<SearchBloc>().add(const SearchHistoryCleared());
                  },
                ),
              ],
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
