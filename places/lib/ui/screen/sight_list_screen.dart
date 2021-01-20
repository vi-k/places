import 'package:flutter/material.dart';
import 'package:places/ui/res/themes.dart';

import '../../domain/mocks_data.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/big_app_bar.dart';
import '../widget/card_list.dart';
import '../widget/mocks.dart';
import '../widget/search_bar.dart';
import '../widget/sight_card.dart';
import 'sight_edit_screen.dart';
import 'sight_search_screen.dart';

/// Экран "Список интересных мест".
class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final sights = Mocks.of(context, listen: true).sights
      ..sort((a, b) => a.coord
          .distance(myMockCoord)
          .compareTo(b.coord.distance(myMockCoord)));

    return Scaffold(
      // appBar: BigAppBar(
      //   title: stringSightListTitle,
      //   bottom: Padding(
      //     padding: commonPadding,
      //     child: Column(
      //       children: [
      //         SearchBar(
      //           onTap: () {
      //             Navigator.push<void>(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => SightSearchScreen(),
      //               ),
      //             );
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTitleDelegate(),
          ),
          // SliverAppBar(
          //   titleSpacing: 0,
          //   stretch: false,
          //   pinned: true,
          //   // backgroundColor: theme.backgroundFirst,
          //   // collapsedHeight: 100,
          //   expandedHeight: 300,
          //   // title: Text(
          //   //   stringSightListTitle,
          //   //   maxLines: 2,
          //   //   style: theme.textBold32Main,
          //   // ),
          //   centerTitle: true,
          //   // title: Align(
          //   //   alignment: Alignment.topCenter,
          //   //   child: Container(
          //   //     color: Colors.orange,
          //   //     child: Wrap(
          //   //       children: [
          //   //         Text(
          //   //           'Список ',
          //   //           style: theme.textBold32Main,
          //   //         ),
          //   //         Text(
          //   //           'интересных мест',
          //   //           style: theme.textBold32Main,
          //   //         ),
          //   //       ],
          //   //     ),
          //   //   ),
          //   // ),
          //   toolbarHeight: 200,
          //   floating: true,
          //   backgroundColor: theme.backgroundFirst,
          //   // backgroundColor: Colors.orange,
          //   flexibleSpace: FlexibleSpaceBar(
          //     collapseMode: CollapseMode.parallax,
          //     // background: Text(
          //     //   stringSightListTitle,
          //     //   style: theme.textBold32Main,
          //     // ),
          //     stretchModes: [StretchMode.zoomBackground],
          //     title: SafeArea(
          //       child: Container(
          //         color: Colors.orange,
          //         child: Padding(
          //           padding: commonPadding,
          //           child: Wrap(
          //             children: [
          //               Text(
          //                 'Список ',
          //                 style: theme.textBold32Main,
          //               ),
          //               Text(
          //                 'интересных мест',
          //                 style: theme.textBold32Main,
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     titlePadding: commonPadding,
          //   ),
          //   bottom: PreferredSize(
          //     preferredSize: const Size.fromHeight(100),
          //     child: Padding(
          //       padding: commonPadding,
          //       child: SearchBar(
          //         onTap: () {
          //           Navigator.push<void>(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => SightSearchScreen(),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: commonPaddingLBR,
                child: SightCard(
                  sightId: sights[index].id,
                  type: SightCardType.list,
                ),
              ),
              childCount: sights.length,
            ),
          ),
        ],
      ),
      // body: CardList(
      //   cardType: SightCardType.list,
      //   list: (context) => Mocks.of(context, listen: true).sights
      //     ..sort((a, b) => a.coord
      //         .distance(myMockCoord)
      //         .compareTo(b.coord.distance(myMockCoord))),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: () {
          Navigator.push<int>(
            context,
            MaterialPageRoute(
              builder: (context) => const SightEditScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(stringNewPlace.toUpperCase()),
      ),
      bottomNavigationBar: const AppNavigationBar(index: 0),
    );
  }
}

class _SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = MyTheme.of(context);
    print(shrinkOffset);
    var offset = (40 - shrinkOffset) / 40;
    if (offset < 0) offset = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: theme.backgroundFirst,
          padding: commonPadding,
          child: Column(
            children: [
              Container(
                child: SizedBox(height: MediaQuery.of(context).padding.top),
              ),
              SizedBox(height: offset * 40),
              Container(
                padding: commonPadding,
                color: theme.backgroundFirst,
                child: Align(
                  alignment: Alignment(offset == 1.0 ? -1 : 0, 0),
                  child: Wrap(
                    children: [
                      Text(
                        'Список ',
                        style: TextStyle.lerp(theme.textMiddle18Main2,
                            theme.textBold32Main, offset),
                      ),
                      Text(
                        'интересных мест',
                        style: TextStyle.lerp(theme.textMiddle18Main2,
                            theme.textBold32Main, offset),
                      ),
                    ],
                  ),
                ),
              ),
              SearchBar(
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SightSearchScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 200;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
