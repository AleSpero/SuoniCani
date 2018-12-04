import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum PlayerState { stopped, playing, paused }

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
    //TODO if not salvato, salva, se salvato, playalo da locale
   /* final result = (playerState == PlayerState.stopped ||
        playerState == PlayerState.paused)
        ? await audioPlayer.play(soundUrl)
        : await audioPlayer.pause();*/

    if (false)//(result == 1)
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