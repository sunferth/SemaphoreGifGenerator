import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:semaphore/classes/angle_signal.dart';
import 'package:semaphore/enum/signal_type.dart';
import 'package:semaphore/widget/AngleSignalPainter.dart';
import 'package:image/image.dart' as img;
import 'package:image/src/util/quantizer.dart';
class AnimationManager{
  double tweenTime;
  double fps;
  double waitTime;
  int width;
  int height;

  AnimationManager({required this.tweenTime, required this.fps, required this.waitTime, required this.width, required this.height});

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
    return image;
  }

  img.Image convertFrameFromByteData(Uint8List toConvert) {
    return img.decodePng(toConvert)!;
  }

  Future<Uint8List> getByteData(AngleSignal signal) async {
    Image image = await generateFrame(signal);
    return ((await image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List()!);
  }

  void AddFrame(img.Image image, img.GifEncoder encoder) {
    encoder.addFrame(image, duration: (fps*60/100).ceil());
  }

  //TODO check if abs(start - end) < abs(end - start)
  AngleSignal createSignalForTweenFrame(AngleSignal start, AngleSignal end, double proportion)
  {
    double leftModifier;
    double rightModifier;
    // if((start.left - end.left).abs() < (end.left - start.left).abs())
    // {
    //   leftModifier = (start.left - end.left) * (1 - proportion) + start.left;
    // }
    // else
    // {
      leftModifier = (end.left - start.left) * proportion + start.left;
    // }
    // if((start.right - end.right).abs() < (end.right - start.right).abs())
    // {
    //   rightModifier = (start.right - end.right) * (1 - proportion) + start.right;
    // }
    // else
    // {
      rightModifier = (end.right - start.right) * proportion + start.right;
    // }
    return AngleSignal(type: start.type, left: leftModifier, right: rightModifier);
  }

  Future<void> downloadToUser(Uint8List toDownload) async {
    await FileSaver.instance.saveFile("TestGif", toDownload, ".gif", mimeType: MimeType.GIF);
  }

  Future<List<Uint8List?>> generateSignalImages(List<AngleSignal> signals) async
  {
    List<Uint8List?> signalPics = List.generate(signals.length, (index) => null);

    List<Future<Uint8List>> signalGenerationFutures = [];

    for(int i = 0; i < signals.length; i++)
    {
      signalGenerationFutures.add(getByteData(signals[i])..then((value){
        signalPics[i] = value;
      }));
    }

    await Future.wait(signalGenerationFutures);

    return signalPics;
  }

  Future<List<Uint8List?>> generateTweenFrames(List<AngleSignal> signals)
  async {

    List<Uint8List?> tweenFrames = List.generate((signals.length - 1) * ((tweenTime * fps).ceil()), (index) => null);
    List<Future<Uint8List>> tweenGenerationFutures = [];

    for(int i = 0; i < signals.length - 1; i++)
    {
      for(int j = 0; j < (tweenTime * fps).ceil(); j++)
      {
        double proportion = j / (tweenTime * fps).ceil();
        AngleSignal signal = createSignalForTweenFrame(signals[i], signals[i  + 1], proportion);
        tweenGenerationFutures.add(getByteData(signal)..then((value){
          tweenFrames[i * (tweenTime * fps).ceil() + j] = value;
        }));
      }
    }

    await Future.wait(tweenGenerationFutures);

    return tweenFrames;
  }

  List<AngleSignal> generateTweenAngles(List<AngleSignal> signals)
  {

    List<AngleSignal> tweenFrames = [];

    for(int i = 0; i < signals.length - 1; i++)
    {
      for(int j = 0; j < (tweenTime * fps).ceil(); j++)
      {
        double proportion = j / (tweenTime * fps).ceil();
        AngleSignal signal = createSignalForTweenFrame(signals[i], signals[i  + 1], proportion);
        tweenFrames.add(signal);
      }
    }

    return tweenFrames;
  }

  Future<Uint8List> generateAnimation(List<AngleSignal> signals, List<Uint8List?> signalImages, List<Uint8List?> tweenFrames, SendPort port) async{

      img.GifEncoder encoder = setupEncoder();
      Uint8List data = Uint8List.fromList([]);

      int signalLength = (waitTime*fps).ceil();
      int tweenLength = (tweenTime*fps).ceil();


      int addedFrames = 0;

      port.send({"message": "Converting Key Frames", "value": 0});
      List<img.Image> signalPics = [];
      for(int i = 0; i < signals.length; i++)
      {
        port.send({"message": "Converting Key Frames", "value": (i + 1)/signals.length});
        signalPics.add(convertFrameFromByteData(signalImages[i]!));
      }

      port.send({"message": "Converting Tween Frames", "value": 0});
      List<img.Image> tweenPics = [];
      for(int i = 0; i < tweenFrames.length; i++)
      {
        port.send({"message": "Converting Tween Frames", "value": (i + 1)/tweenFrames.length});
        tweenPics.add(convertFrameFromByteData(tweenFrames[i]!));
      }

      List<img.Image?> frames = [];

      port.send({"message": "Generating Frame List", "value": 50});

      for(int i = 0; i < signals.length - 1; i++)
      {
        frames.addAll(List.generate(signalLength, (index) => signalPics[i]));
        if(i + 1 < signals.length)
        {
          frames.addAll(tweenPics.sublist(i * tweenLength, (i + 1) * tweenLength));
        }
      }

      port.send({"message": "Adding Frames", "value": 0});

      for(int i = 0; i < frames.length; i++)
      {
        encoder.addFrame(frames[i]!, duration: (100/fps).ceil());
        addedFrames++;
        port.send({"message": "Adding Frames", "value": addedFrames/frames.length});
      }

      data =  encoder.finish()!;

      port.send({"message": "Done", "value": data});


      return data;
    }

    List<AngleSignal> generatePreviewSignals(List<AngleSignal> signals)
    {
      int signalLength = (waitTime*fps).ceil();
      int tweenLength = (tweenTime*fps).ceil();

      List<AngleSignal> tweenSignals = generateTweenAngles(signals);

      List<AngleSignal> frames = [];


      for(int i = 0; i < signals.length; i++)
      {
        frames.addAll(List.generate(signalLength, (index) => signals[i]));
        if(i < signals.length - 1)
        {
          frames.addAll(tweenSignals.sublist(i * tweenLength, i * tweenLength + tweenLength));
        }
      }

      return frames;
    }
}