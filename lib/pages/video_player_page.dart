import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

enum Source {
  Assets, Network
}

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late CustomVideoPlayerController _customVideoPlayerController;
  Source currentSource = Source.Assets;
  String asstVideoPath = "assets/video/views.mp4";
  Uri videoUrl = Uri.parse( "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer(currentSource);
  }

  void initializeVideoPlayer(Source source) {
    VideoPlayerController _videoPlayerController;
    setState(() {
      isLoading = true;
    });
    if(source == Source.Assets){
      _videoPlayerController = VideoPlayerController.asset(asstVideoPath)
        ..initialize().then((value) {
          setState(() {
            isLoading = false;
          });
        });
    }
    else if(source == Source.Network){
      _videoPlayerController = VideoPlayerController.networkUrl(videoUrl)..initialize().then((value){
        setState(() {
          isLoading = false;
        });
       });
    }else{
      return;
    }
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: _videoPlayerController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ?
      Center(child: CircularProgressIndicator(color: Colors.redAccent,),)
      : Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomVideoPlayer(customVideoPlayerController: _customVideoPlayerController),
          _sourceButton()
        ],
      ),
    );
  }

  Widget _sourceButton(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MaterialButton(
            color: Colors.redAccent,
            child: const Text('Network', style: TextStyle(color: Colors.white),),
            onPressed: (){
              setState(() {
                currentSource = Source.Network;
                initializeVideoPlayer(currentSource);
              });
            }),
        MaterialButton(
            color: Colors.redAccent,
            child: const Text('Asset', style: TextStyle(color: Colors.white),),
            onPressed: (){
              currentSource = Source.Assets;
              initializeVideoPlayer(currentSource);
            })
      ],
    );
  }


}
