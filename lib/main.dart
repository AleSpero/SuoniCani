import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(new MyApp());

enum PlayerState { stopped, playing, paused }

class MyApp extends StatelessWidget {

  final ThemeData androidTheme = new ThemeData(
    primarySwatch: Colors.blue,
  );

  final ThemeData iosTheme = new ThemeData(
    primaryColor: Colors.blue
  );



  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Suoni Cani',
      theme:  defaultTargetPlatform == TargetPlatform.android ?
              androidTheme :
              iosTheme,
      home: new MainView(title: 'Suoni Cani'),
    );
  }
}

AudioPlayer audioPlayer;

class MainView extends StatefulWidget {
  MainView({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  MainViewState createState() => new MainViewState();
}

class MainViewState extends State<MainView> {
  List<SoundItem> sounds = new List<SoundItem>();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();

    audioPlayer.setErrorHandler((msg) {
      //TODO
    });

    audioPlayer.setCompletionHandler(() {
      //TODO
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new StreamBuilder(
        //Prendo i dati da firebase
          stream: Firestore.instance.collection('sounds').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return new Center(
              child: new CircularProgressIndicator() //TODO riguarda
            );
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  DocumentSnapshot ds = snapshot.data.documents[index];

                  Widget soundItem = new SoundItem(description: ds['description'],
                      author: ds['author'],
                      soundFileName: ds['soundPath']
                  );

                  if(defaultTargetPlatform == TargetPlatform.iOS) {
                    return new Column(
                      children: <Widget>[
                        soundItem,
                        new Divider(height: 1.0)
                      ],
                    );
                  }

                  else return soundItem;


                }
            );
          }
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null,
        tooltip: 'Stop',
        child: new Icon(Icons.stop),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SoundItem extends StatefulWidget {
  final String description;
  final String author;
  final soundFileName; //giusto?

  final cardElevation = defaultTargetPlatform == TargetPlatform.android ? 3.0 : 0.0;
  final horizontalCardMargin = defaultTargetPlatform == TargetPlatform.android ? 15.0 : 0.0;
  final verticalCardMargin = defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0;
  final topCardMargin = defaultTargetPlatform == TargetPlatform.android ? 20.0 : 0.0;
  final expandedPadding = defaultTargetPlatform == TargetPlatform.android ? 15.0 : 0.0;


  SoundItem({Key key, this.description, this.author, this.soundFileName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new SoundItemState();
}

class SoundItemState extends State<SoundItem> {


  PlayerState playerState = PlayerState.stopped;
  IconData iconState = Icons.play_arrow;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(top: widget.topCardMargin),
      child: new Card(
        elevation: widget.cardElevation,
        margin: EdgeInsets.symmetric(vertical: widget.verticalCardMargin, horizontal: widget.horizontalCardMargin),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Container(
                child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(widget.description, style: new TextStyle(fontSize: 20.0)),
                new Text(widget.author, style:  new TextStyle(fontSize: 12.0))],
              ),
                padding: EdgeInsets.only(left: 20.0, top: widget.expandedPadding, bottom: widget.expandedPadding),
              )
            ),
            new Container(
                padding: EdgeInsets.all(10.0),
            child : new IconButton(
                iconSize: 27.5,
                icon: new Icon(iconState, color: Theme.of(context).primaryColor),
                onPressed: () => manageSound(widget.soundFileName))
            )
          ],
        ),
      ),
    );
  }

  void manageSound(String soundUrl) async {
    //riproduco suono
    final result = (playerState == PlayerState.stopped ||
            playerState == PlayerState.paused)
        ? await audioPlayer.play(soundUrl)
        : await audioPlayer.pause();

    if (result == 1)
      //Success
      setState(() {
        //Aggiorno icona
        if (playerState == PlayerState.stopped ||
            playerState == PlayerState.paused) {
          playerState = PlayerState.playing;
          iconState = Icons.pause;
        } else {
          playerState = PlayerState.paused;
          iconState = Icons.play_arrow;
        }
      });

    //TODO setstate + azione
  }
}
