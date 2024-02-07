import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  int index = 1;
  String imageUrl = '';
  String heading = '';
  String description = '';
  String readMore = '';

  get data => null;
  @override
  void initState() {
    super.initState();
    getNews();
  }

  _launchURLApp() async {
    var url = Uri.parse(readMore);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future getNews() async {
    final response = await http.get(
      Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=92b0d30aa4c941d18bec50e86abdd320',
      ),
    );
    setState(() {
      final data = jsonDecode(response.body);
      imageUrl = data['articles'][index]['urlToImage'];
      heading = data['articles'][index]['title'];
      description = data['articles'][index]['description'];
      readMore = data['articles'][index]['url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SafeArea(
        child: Column(
          children: [
            ClipRRect(
              child: Image.network(
                imageUrl,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Text(
                    heading,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            index++;
            getNews();
          });
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.navigate_next,
          size: 40,
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: _launchURLApp,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
          ),
          height: 70,
          width: double.infinity,
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'To read more',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'Tap here',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
