import 'package:ao3_scraper/ao3_scraper.dart';

void main() {
  var favWork = Ao3Client.searchWorks("Yesterday Upon the Stair");
  favWork.then((value) {
    // Prints title: Yesterday, Upon the Stair,
    // fandom: Sherlock (TV),
    // author: PhoenixDragon,
    // description: Even if there was the remotest possibility that he was, indeed, Sherlock (and not a random figment of madness come to solid, breathing life),
    // it still wasn't Sherlock. Too much time had passed.,
    // number of chapters: 1,
    // workID: 567621
    print(value[0].toString());

    print(Ao3Client.getURLfromWorkID(
        value[0].workID)); // Prints https://archiveofourown.org/works/567621/
  });

  var bookmarkedWorks = Ao3Client.getBookmarksFromUsername(
      "John"); // Returns all works found in the first page of bookmarks for the given username.
  bookmarkedWorks.then((works) {
    for (var work in works) {
      print(work.toString());
    }
  });
}
