<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

This packages provides a "fake API" for accessing Ao3 works and bookmarks by webscraping the website. This package does not work with anything requiring authentication into Ao3.

## Features

You can search for works given a certain keyword, or search through bookmarks of a person. As of now, only the first page of search/bookmarks is scraped. 

## Usage
 
```dart
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
```
