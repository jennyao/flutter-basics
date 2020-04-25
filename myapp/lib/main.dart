// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//Written Dart code.
//Used hot reload for a faster development cycle.
//Implemented a stateful widget, adding interactivity to your app.
//Created a route and added logic for moving between the home route and the new route.
//Learned about changing the look of your app's UI using themes.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour Name Generator',
      theme: ThemeData(
        primaryColor: Colors.amber,
        backgroundColor: Colors.black54,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(   // Add 20 lines from here...
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Tours'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    //this function calls _buildRow() once per word pair
    //displays each new pair in a ListTile, which allows you to make the rows more attractive in the next step
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {        /*1. The itemBuilder callback is called once per suggested word pairing, and places each suggestion into a ListTile row.
                                                      For even rows, the function adds a ListTile row for the word pairing. For odd rows, the function adds a Divider widget
                                                      to visually separate the entries. Note that the divider might be difficult to see on smaller devices.*/
          if (i.isOdd) return Divider();         /*2. Add a one-pixel-high divider widget before each row in the ListView.*/

          final index = i ~/ 2;                  /*3. The expression i ~/ 2 divides i by 2 and returns an integer result.
                                                      For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2. This calculates the actual number of word pairings in the ListView,
                                                      minus the divider widgets.*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4. If you’ve reached the end of the available word pairings, then generate 10 more and add them to the suggestions list.*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
   final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,  //this adds heart icons
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //1.0 The following was the first iteration in creating random word pairs
    //final wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase);
    //2.0 The following is the new iteration in using the _buildSuggestions() function, rather than directly calling the word generation library
    return Scaffold(  //Scaffold implements the basic Material Design visual layout
      appBar: AppBar(
        title: Text('Tour Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),  //this pushes a route(new page) updates that display. then it gets saved and pushes back to the Navigator
        ]
      ),
      body: _buildSuggestions(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
