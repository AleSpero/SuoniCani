import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';

void main() => runApp(new MyApp());

enum PlayerState {stopped, playing, paused}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Suoni Cani',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MainView(title: 'Suoni Cani'),
    );
  }
}
 AudioPlayer audioPlayer;
final String path = "TODO";

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
  void initState(){
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer(){
    audioPlayer = new AudioPlayer();

    audioPlayer.setErrorHandler((msg) {
      //TODO
    });

    audioPlayer.setCompletionHandler(() {
      //TODO
    });
  }

  void initAudioList(){
    sounds.add(new SoundItem(description: "Prova", soundFileName: "prova"));
    sounds.add(new SoundItem(description: "Prova", soundFileName: "prova"));
    sounds.add(new SoundItem(description: "Prova", soundFileName: "prova"));
    sounds.add(new SoundItem(description: "Prova", soundFileName: "prova"));
    sounds.add(new SoundItem(description: "Prova", soundFileName: "prova"));
    sounds.add(new SoundItem(description: "Prova", soundFileName: "prova"));
    sounds.add(new SoundItem(description: "Prova", soundFileName: "prova"));
    sounds.add(new SoundItem(description: "Prova", soundFileName: "prova"));
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
      body: new ListView.builder(
          itemBuilder: null
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null,
        tooltip: 'Stop',
        child: new Icon(Icons.stop),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SoundItem extends StatefulWidget{
 final String description;
 final soundFileName; //giusto?

  SoundItem({Key key, this.description, this.soundFileName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new SoundItemState();

}

class SoundItemState extends State<SoundItem>{

  IconData iconState = Icons.play_arrow;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Flexible(
              child: new Text(widget.description)
          ),
          new IconButton(
              icon: new Icon(iconState),
              onPressed: () => manageSound(widget.soundFileName)
          )
        ],
      ),
    );
  }

  void manageSound(String fileName) async {
    //riproduco suono
     final result = await audioPlayer.play(path+fileName, isLocal: true);

     if(result == 1)
       //Success
       setState(() {
         //Aggiorno icona
        iconState = Icons.pause;
       });

    //TODO setstate + azione
  }

}
