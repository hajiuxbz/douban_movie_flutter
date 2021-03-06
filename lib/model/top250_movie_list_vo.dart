import 'movie_item_vo.dart';

class Top250MovieListVo {
  int count;
  int start;
  int total;
  String title;
  List<MovieItemVo> movieItems;


  Top250MovieListVo(this.count, this.start, this.total, this.title, this.movieItems);

  Top250MovieListVo.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    start = json['start'];
    total = json['total'];
    title = json['title'];

    List<MovieItemVo> movieItemData = [];
    for (var i = 0; i < json['subjects'].length; i++) {
      movieItemData.add(MovieItemVo.fromJson(json['subjects'][i]));
    }
    movieItems = movieItemData;
  }


}