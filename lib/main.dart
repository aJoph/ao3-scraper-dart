import 'package:ao3_scraper/src/ao3_scraper_base.dart';

void main() async {
  var a = await Ao3Client.getBookmarksFromUsername("JooJASL");
  for (var element in a) {
    print(element.title);
  }
}
