import 'dart:typed_data';
import 'dart:html';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:semaphore/classes/angle_signal.dart';
import 'package:semaphore/data/bloc/TestEvent.dart';
import 'package:semaphore/enum/signal_type.dart';
import 'package:semaphore/widget/AngleSignalPainter.dart';
import 'package:image/image.dart' as img;
import 'package:image/src/util/quantizer.dart';

import '../data/bloc/TestBloc.dart';

class AnimationManager{
  double tweenTime;
  double fps;
  double waitTime;
  int width;
  int height;
  TestBloc bloc;

  AnimationManager({required this.tweenTime, required this.fps, required this.waitTime, required this.width, required this.height, required this.bloc});

  img.GifEncoder setupEncoder(){
    img.GifEncoder encoder = img.GifEncoder();
    encoder.quantizerType = QuantizerType.octree;
    return encoder;
  }

  Future<Image> generateFrame(AngleSignal signal) async{
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    AngleSignalPainter(AngleSignal(type: SignalType.alphabetical, left: signal.left, right: signal.right)).paint(canvas, Size(width.toDouble(), height.toDouble()));
    Picture pic = recorder.endRecording();
    Image image = await pic.toImage(width, height);
    print("generated");
    return image;
  }

  Future<img.Image> convertFrame(Image toConvert) async {
    return img.decodePng(((await toConvert.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List()!))!;
  }

  Future<img.Image> processFrame(AngleSignal signal) async {
    Image image = await generateFrame(signal);
    return await convertFrame(image);
  }

  void AddFrame(img.Image image, img.GifEncoder encoder) {
    encoder.addFrame(image, duration: (fps*60/100).ceil());
  }

  //TODO check if abs(start - end) < abs(end - start)
  AngleSignal createSignalForTweenFrame(AngleSignal start, AngleSignal end, double proportion)
  {
    return AngleSignal(type: start.type, left: (end.left - start.left) * proportion + start.left, right: (end.right - start.right) * proportion + start.right);
  }

  void downloadToUser(Uint8List toDownload) {
    final blob = Blob([toDownload]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = document.createElement('a') as AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = "test.gif";
    document.body!.children.add(anchor);

    anchor.click();

    document.body!.children.remove(anchor);
    Url.revokeObjectUrl(url);
  }

  Future<Uint8List> generateAnimation(List<AngleSignal> signals) async{
    bloc.add(StartProcessingEvent());
      img.GifEncoder encoder = setupEncoder();
      Uint8List data = Uint8List.fromList([]);

      int signalLength = (waitTime*fps).ceil();
      int tweenLength = (tweenTime*fps).ceil();


      int addedFrames = 0;

      List<img.Image?> signalPics = List.generate(signals.length, (index) => null);

      int signalPicsFinished = 0;

      bloc.add(UpdateProcessingevent("Generating Key Frames", 0));

    List<Future<img.Image?>> signalGenerationFutures = [];

      for(int i = 0; i < signals.length; i++)
      {
        signalGenerationFutures.add(processFrame(signals[i]).then((value){
          signalPics[i] = value;
        }));
      }

      bloc.add(UpdateProcessingevent("Generating Tween Frames", 0));

      List<img.Image?> tweenPics = List.generate((signals.length - 1) * tweenLength, (index) => null);

      int tweenPicsFinished = 0;



      List<Future<img.Image?>> tweenGenerationFutures = [];

      for(int i = 0; i < signals.length - 1; i++)
      {
        for(int j = 0; j < tweenLength; j++)
        {
          double proportion = j / tweenLength;
          AngleSignal signal = createSignalForTweenFrame(signals[i], signals[i  + 1], proportion);
          tweenGenerationFutures.add(processFrame(signal).then((value){
            tweenPics[i * tweenLength + j] = value;
          }));
          // generateFrame(signal).then((value) {
          //   tweenGenerationFutures.add(convertFrame(value).then((converted){
          //     tweenPics[i * tweenLength + j] = converted;
          //     tweenPicsFinished++;
          //     bloc.add(UpdateProcessingevent("Generating Tween Frames", tweenPicsFinished/((signals.length - 1) * tweenLength)));
          //   }));
          // });
        }
      }

      await Future.wait([...signalGenerationFutures, ...tweenGenerationFutures]);

      List<img.Image?> frames = [];

      bloc.add(UpdateProcessingevent("Generating Frame List", 50));

      for(int i = 0; i < signals.length - 1; i++)
      {
        frames.addAll(List.generate(signalLength, (index) => signalPics[i]));
        if(i + 1 < signals.length)
        {
          frames.addAll(tweenPics.sublist(i * tweenLength, (i + 1) * tweenLength));
        }
      }

      bloc.add(UpdateProcessingevent("Adding Frames", 0));

      for(int i = 0; i < frames.length; i++)
      {
        encoder.addFrame(frames[i]!, duration: (100/fps).ceil());
        addedFrames++;
        bloc.add(UpdateProcessingevent("Adding Frames",addedFrames/frames.length));
      }

      data =  encoder.finish()!;

      downloadToUser(data);

      bloc.add(StopProcessingEvent());

      return data;
    }
}