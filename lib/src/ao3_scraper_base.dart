import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

void main() {
  Ao3Client.getBookmarksFromUsername("JooJASL");
}

/// Ao3Client is a Singleton class that exposes all of the library's functions as its methods.
class Ao3Client {
  /// searchWorks searches the first page of results for the query in the argument.
  ///
  /// If a work has multiple fandoms, only the first is listed.
  ///
  /// If the webscraping does not work for any of the String fields in the work class, "Unknown" will be placed instead.
  ///
  /// If the number of chapters or workID can't be found, 1 will be placed instead.
  /// This is primarily because OneShots don't work the sameway in the chapter count department.
  static Future<List<Work>> searchWorks(final String nameOfWork) async {
    final worksFound = <Work>[];
    final resp = await http.get(Uri.parse(
        "https://archiveofourown.org/works/search?work_search%5Bquery%5D=$nameOfWork"));

    if (resp.statusCode == 404) {
      throw ("Error 404");
    }

    final works = parse(resp.body).querySelectorAll("li.work");

    for (final work in works) {
      worksFound.add(_getWork(work));
    }

    return worksFound;
  }

  /// getBookmarksFromusername searches the public bookmarks from the username in the argument.
  ///
  /// If a work has multiple fandoms, only the first is listed.
  ///
  /// Currently, it only searches the first page of bookmarks sorted by date of bookmark.
  /// If it fails to find a value, it will be set to "Unknown" in the case of strings or 1 in the case of ints.
  ///
  /// Will throw error if user is not found, but not if user has 0 bookmarks.
  static Future<List<Work>> getBookmarksFromUsername(String username,
      {int page = 1}) async {
    final bookmarkedWorks = <Work>[];

    final resp = await http.get(Uri.parse(
        "https://archiveofourown.org/users/$username/bookmarks?page=$page"));

    if (resp.statusCode == 404) {
      throw (StateError("No user found."));
    }

    var html = parse(resp.body);

    bookmarkedWorks.addAll(_getWorksFromPage(html));

    var morePagesRemain = true;
    while (morePagesRemain) {
      var nextButton = html.getElementById("next");
      if (nextButton == null) {
        morePagesRemain = false;
        break;
      }

      final resp = await http.get(Uri.parse(nextButton.attributes['href']!));

      if (resp.statusCode == 404) {
        throw (StateError("No user found."));
      }

      html = parse(resp.body);
      bookmarkedWorks.addAll(_getWorksFromPage(html));
    }

    return bookmarkedWorks;
  }

  /// getURL
  static String getURLfromWorkID(int workID) {
    return "https://archiveofourown.org/works/$workID/";
  }

  static List<Work> _getWorksFromPage(Document html) {
    final bookmarkedWorks = <Work>[];

    final bookmarks = html.querySelectorAll("li.bookmark");
    for (final bookmark in bookmarks) {
      bookmarkedWorks.add(_getWork(bookmark));
    }

    return bookmarkedWorks;
  }

  /// _getWork is a helper function meant to parse the HTML Element and return an appropriate Work().
  static Work _getWork(Element work) {
    return Work(
      title: work.querySelector("h4.heading > a[href]")?.text ?? "Unknown.",
      description:
          work.querySelector("blockquote.summary")?.text.trim() ?? "Unknown.",
      author: work.querySelector('a[rel="author"]')?.text ?? "Unknown.",
      fandom: Fandom(
        name: work.querySelector("h5.fandoms > a.tag")?.text ?? "Unknown.",
        url: work.querySelector("h5.fandoms > a")?.attributes["href"] ??
            "Unknown.",
      ),
      workID: int.parse(work
              .querySelector("h4.heading > a[href]")
              ?.attributes["href"]
              ?.substring(7) ?? // In order to remove the "/works/" prefix.
          "1"),
      link: getURLfromWorkID(int.parse(work // TODO: Make this less stupid.
              .querySelector("h4.heading > a[href]")
              ?.attributes["href"]
              ?.substring(7) ?? // In order to remove the "/works/" prefix.
          "1")),
      numberOfChapters:
          int.parse(work.querySelector("dd.chapters > a[href]")?.text ?? "1"),
    );
  }
}

class Work {
  final String title, description, author, link;
  final int numberOfChapters, workID;
  final Fandom fandom;
  const Work({
    required this.title,
    required this.fandom,
    required this.author,
    required this.description,
    required this.link,
    required this.workID,
    required this.numberOfChapters,
  });

  factory Work.fromJson(Map<String, Object?> json) {
    final fandom = jsonDecode(json['fandom'] as String);
    return Work(
      title: json['title'] as String,
      fandom: Fandom(name: fandom['name'], url: fandom['url']),
      author: json['author'] as String,
      description: json['description'] as String,
      workID: json['workID'] as int,
      link: json['link'] as String,
      numberOfChapters: json['numberOfChapters'] as int,
    );
  }

  factory Work.fromURL(String url) {
    // TODO: Implement Work.fromURL()
    throw ("Not implemented yet.");
  }

  @override
  String toString() {
    return 'title: $title, fandom: ${fandom.name}, author: $author, description: $description, number of chapters: $numberOfChapters, workID: $workID';
  }

  @override
  bool operator ==(Object other) {
    return other is Work && workID == other.workID;
  }

  @override
  int get hashCode {
    return Object.hash(title, workID);
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'description': description,
      'workID': workID,
      'numberofChapters': numberOfChapters,
      'fandom': fandom.toJson(),
    };
  }
}

class Fandom {
  final String name, url;
  Fandom({required this.name, required this.url});
  factory Fandom.fromJson(Map<String, Object?> json) {
    return Fandom(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  String toString() {
    return '$name, $url';
  }

  @override
  bool operator ==(Object other) {
    return other is Fandom && name == other.name && url == other.url;
  }

  @override
  int get hashCode {
    return Object.hash(name, url);
  }
}

class Chapter {
  // TODO: Although the Chapter class exists, it has no actual use as I have yet to build a factory method in Ao3Client for it.
  final String title, summary, notes;
  final int chapterNumber, chapterID;
  Chapter({
    required this.title,
    required this.summary,
    required this.notes,
    required this.chapterNumber,
    required this.chapterID,
  });
}
