/// Replicates an API (as Ao3 does not have a public one) by scraping archiveofourown.org for relevant information.
///
/// This library cannot do anything that requires authentication to access.
library ao3_scraper;

export 'src/ao3_scraper_base.dart' show Ao3Client, Fandom, Work;
