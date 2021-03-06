import 'package:carousel_slider/carousel_slider.dart';
import 'package:douban_movie_flutter/i10n/localization_intl.dart';
import 'package:douban_movie_flutter/model/movie_item_vo.dart';
import 'package:douban_movie_flutter/provider/billboard_provider.dart';
import 'package:douban_movie_flutter/service/resource_manager.dart';
import 'package:douban_movie_flutter/service/router_manager.dart';
import 'package:douban_movie_flutter/utils/screen_util.dart';
import 'package:douban_movie_flutter/widget/billboard_banner_widget.dart';
import 'package:douban_movie_flutter/widget/search_label_widget.dart';
import 'package:douban_movie_flutter/widget/skeleton/billboard_skeleton.dart';
import 'package:douban_movie_flutter/widget/movie_item_widget2.dart';
import 'package:douban_movie_flutter/widget/common_section_widget.dart';
import 'package:douban_movie_flutter/widget/common_empty_widget.dart';
import 'package:douban_movie_flutter/widget/common_error_widget.dart';
import 'package:douban_movie_flutter/widget/search_widget.dart';
import 'package:douban_movie_flutter/widget/view_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 首页榜单页
 */
class BillboardPage extends StatefulWidget {
  @override
  State<BillboardPage> createState() {
    return _BillboardState();
  }

  BillboardPage({Key key}) : super(key: key);
}

class _BillboardState extends State<BillboardPage>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: SearchLabelWidget(
            onTap: () {
              Navigator.of(context).pushNamed(RouteName.searchPage);
            },
          ),
        ),
        body: ViewStateWidget<BillboardProvider>(
          provider: BillboardProvider(context),
          onProviderReady: (provider) async {
            await provider.initData();
          },
          builder: (context, BillboardProvider provider, child) {
            if (provider.isBusy) {
              return BillboardSkeleton();
            } else if (provider.isEmpty) {
              return CommonEmptyWidget(onPressed: provider.initData);
            } else if (provider.isError) {
              return CommonErrorWidget(
                  error: provider.viewStateError, onPressed: provider.initData);
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CommonSection(
                    title: DouBanLocalizations.of(context).top_250,
                    action: DouBanLocalizations.of(context).all,
                    backgroundColor: ThemeHelper.wrapDarkBackgroundColor(context, Color(0xFFF7F7F7)),
                    padding: EdgeInsets.fromLTRB(15, 8, 5, 8),
                    titleStyle: TextStyle(
                        color: ThemeHelper.wrapDarkColor(context, Colors.black87),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    actionStyle: TextStyle(
                      color: ThemeHelper.wrapDarkColor(context, Colors.black87),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouteName.billboardTop250Page);
                    },
                  ),
                  _buildTop250GridView(context, provider.top250MovieItemVos),
                  CommonSection(
                    title: DouBanLocalizations.of(context).other_billboard,
                    backgroundColor: ThemeHelper.wrapDarkBackgroundColor(context, Color(0xFFF7F7F7)),
                    padding: EdgeInsets.fromLTRB(15, 8, 5, 8),
                    titleStyle: TextStyle(
                        color: ThemeHelper.wrapDarkColor(context, Colors.black87),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    actionStyle: TextStyle(
                      color: ThemeHelper.wrapDarkColor(context, Colors.black87),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _buildOtherBillboardBaners(context, <Widget>[
                    BillboardBannerWidget(
                        title: provider.weeklyBannerEntity.title,
                        movieItemVos: provider.weeklyBannerEntity.movieItemVos,
                        routerName: provider.weeklyBannerEntity.routerName),
                    BillboardBannerWidget(
                        title: provider.newMovieBannerEntity.title,
                        movieItemVos:
                            provider.newMovieBannerEntity.movieItemVos,
                        routerName: provider.newMovieBannerEntity.routerName),
                    BillboardBannerWidget(
                        title: provider.usboxBannerEntity.title,
                        movieItemVos: provider.usboxBannerEntity.movieItemVos,
                        routerName: provider.usboxBannerEntity.routerName),
                  ])
                ],
              ),
            );
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildTop250GridView(BuildContext context, data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //横轴三个子widget
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            MovieItemVo item = data[index];
            return MovieItemWidget2(movieItemVo: item);
          }),
    );
  }
}

Widget _buildOtherBillboardBaners(BuildContext context, List<Widget> banners) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      width: ScreenUtil.width,
      height: 200,
      child: CarouselSlider(
        aspectRatio: 15 / 9,
        items: banners,
      ));
}
