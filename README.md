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
void main() async {
  var favWork = await Ao3Client.searchWorks("Yesterday Upon the Stair");
  print(favWork[0].fandom) // Prints Sherlock (TV) 
  print(favWork[0].link) // Prints https://archiveofourown.org/works/567621/

  // You can also get link to the work from the workID
  var link = Ao3Client.getURLfromWorkID(favWork[0].workID);
  print(link) // Prints https://archiveofourown.org/works/567621/

  // Returns a list of bookmarks by the given user. Optionally, you may choose from which of the bookmark pages (if more than one)
  // you'd like to start scraping from. The scraper will always scrape from the starting point to the end; there's no way to scrape 
  // only one page.
  var bookmarkedWorks = await Ao3Client.getBookmarksFromUsername("John") 
}
```
