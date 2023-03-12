import 'package:ashton_jones_medium_feed/core/data/model/MediumArticle.dart';
import 'package:ashton_jones_medium_feed/styles/colors.dart';
import 'package:ashton_jones_medium_feed/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late RssFeed _rssFeed; // RSS Feed Object

  List<MediumArticle> _mediumArticles = [];

  Future<RssFeed?> getMediumRSSFeedData() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(
          'https://cors-anywhere.herokuapp.com/https://radio20158.org/feed/podcast/'));

      return RssFeed.parse(response.body);
    } catch (e) {
      print(e);
    }
    return null;
  }

  updateFeed(feed) {
    setState(() {
      _rssFeed = feed;
    });
  }

  Future<void> launchArticle(String url) async {
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    // Clear old data in the list
    _mediumArticles.clear();

    getMediumRSSFeedData().then((feed) {
      // Update the _feed variable
      updateFeed(feed);

      // print feed Metadata
      print('FEED METADATA');
      print('------------------');
      print('Link: ${feed?.link}');
      print('Description: ${feed?.description}');
      print('Docs: ${feed?.docs}');
      print('Last build data: ${feed?.lastBuildDate}');
      print('Number of items: ${feed?.items?.length}');

      // Get the data for each item in the feed

      /// Get the title of each item
      if (feed != null) {
        for (RssItem rssItem in feed.items!) {
          // Only print the titles of the articles: comments do not have a description (subtitle), but articles do
          if (rssItem.description != null) {
            print('Title: ${rssItem.title}');
            print('Link: ${rssItem.link}');
            print('Publish date: ${rssItem.pubDate.toString()}');
            print('mp3suca ${rssItem.enclosure}');

            // Create a new Medium article from the rssitem
            MediumArticle mediumArticle = MediumArticle(
              title: rssItem.title!,
              link: rssItem.link!,
              datePublished: rssItem.pubDate.toString(),
              enclosure: rssItem.enclosure.toString(),
            );

            // Add the article to the list
            _mediumArticles.add(mediumArticle);
          }
        }
      }
      // Check to see if list has been populated
      for (MediumArticle article in _mediumArticles) {
        print('List contains: ${article.title}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ashton Jones\' Medium Feed'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _mediumArticles.length,
        padding: EdgeInsets.all(8),
        itemBuilder: (BuildContext buildContext, int index) {
          return Container(
            child: ListTile(
              title: Text(_mediumArticles[index].title),
              subtitle: Text(_mediumArticles[index].datePublished),
              onTap: () => launchArticle(_mediumArticles[index].enclosure),
              trailing: Icon(Icons.arrow_right),
            ),
          );
        },
      ),
    );
  }
}
