

import 'dart:math';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semaphore/data/bloc/TestBloc.dart';
import 'package:semaphore/widget/AngleSignalPainter.dart';

import '../data/bloc/TestEvent.dart';
import '../data/bloc/TestState.dart';
import 'circular_progress_painter.dart';

class MainView extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Semaphore Gif Generator", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 48),),
        SizedBox(height: 15,),
        SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Expanded(child: Container()),
            Expanded(
              child: BlocTextField(BlocProvider.of<TestBloc>(context).state.text, (text){
                BlocProvider.of<TestBloc>(context).add(UpdateTextEvent(text));
              })
            ),
            if(!BlocProvider.of<TestBloc>(context).state.processing) SizedBox(width: 15,),
            !BlocProvider.of<TestBloc>(context).state.processing ? (!BlocProvider.of<TestBloc>(context).state.previewing ? SizedBox(width: 100, child: PreviewButton()) : SizedBox(width: 100, child: CancelPreviewButton())) : Container(),
            SizedBox(width: 15,),
            BlocProvider.of<TestBloc>(context).state.processing ? SizedBox(width: 100, child: CancelButton()) : SizedBox(width: 100, child: GenerateButton()),
            Expanded(child: Container())
          ],),
        ),
        SizedBox(height: 15,),
        Expanded(
          child: Row(
            children: [
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: BlocProvider.of<TestBloc>(context).state.processing ? [
                Text("Processing", style: TextStyle(color: Colors.white, fontSize: 20)),
                Text("Current Step: ${BlocProvider.of<TestBloc>(context).state.label}", style: TextStyle(color: Colors.white, fontSize: 20),),
                SizedBox(height: 10),
                SizedBox(
                  width: 256,
                  height: 256,
                  child: CustomPaint(
                    painter: CircularProgressPainter(
                        value: BlocProvider.of<TestBloc>(context).state.percentProcessing,
                        startAngle: 135/180 * pi,
                        sweepAngle: 270/180 * pi,
                        baseColor: Colors.blueGrey,
                        progressColor: Colors.green.shade800,
                        baseWidth: 12,
                        progressWidth: 8
                    ),
                  ),
                )
                ] : [
                  Container(
                    width: 256,
                    height: 256,
                    padding: EdgeInsets.all(10),
                    color: Colors.black,
                    child: BlocProvider.of<TestBloc>(context).state.data != null && ! BlocProvider.of<TestBloc>(context).state.previewing ? Image.memory(BlocProvider.of<TestBloc>(context).state.data!) : Center(child: BlocProvider.of<TestBloc>(context).state.previewing ? Preview() : Text(BlocProvider.of<TestBloc>(context).state.data != null ? "Data got" : "Press 'Preview' to View Gif, or 'Generate GIF' to have more options", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),),
                  ),
                  const SizedBox(height: 15,),
                  if(BlocProvider.of<TestBloc>(context).state.data != null) SizedBox(height: 15,),
                  if(BlocProvider.of<TestBloc>(context).state.data != null) Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 150, height: 50, child: SaveButton()),
                      SizedBox(width: 10),
                      SizedBox(width: 150, height: 50, child: CopyButton()),
                    ],
                  ),
                ],)
              ),
              VerticalDivider(color: Colors.grey,),
              Expanded(child: Column(
                children: [

                  Text("Gif Generator Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),),
                  if((BlocProvider.of<TestBloc>(context).state.previewing || BlocProvider.of<TestBloc>(context).state.processing))
                    Text("(Locked While Previewing or Processing)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),),
                  SizedBox(height: 30,),
                  Text("FPS: ${BlocProvider.of<TestBloc>(context).state.fps}", style: TextStyle(color: Colors.white),),
                  Slider(min: 1, max: 60, value: BlocProvider.of<TestBloc>(context).state.fps.toDouble(), divisions: 60, onChanged: (value){
                    if(!(BlocProvider.of<TestBloc>(context).state.previewing || BlocProvider.of<TestBloc>(context).state.processing))
                    {
                      BlocProvider.of<TestBloc>(context).add(UpdateSettingsEvent(fps: value.ceil()));
                    }
                  },),
                  SizedBox(height: 30,),
                  Text("Signal Time: ${BlocProvider.of<TestBloc>(context).state.signalTime.toStringAsFixed(1)}", style: TextStyle(color: Colors.white),),
                  Slider(min: 0.1, max: 10, value: BlocProvider.of<TestBloc>(context).state.signalTime, divisions: 99, onChanged: (value){
                    if(!(BlocProvider.of<TestBloc>(context).state.previewing || BlocProvider.of<TestBloc>(context).state.processing)) {
                      BlocProvider.of<TestBloc>(context).add(UpdateSettingsEvent(
                          signalTime: value));
                    }
                  },),
                  SizedBox(height: 30,),
                  Text("Tween Time: ${BlocProvider.of<TestBloc>(context).state.tweenTime.toStringAsFixed(1)}", style: TextStyle(color: Colors.white),),
                  Slider(min: 0, max: 10, value: BlocProvider.of<TestBloc>(context).state.tweenTime, divisions: 100, onChanged: (value){
                    if(!(BlocProvider.of<TestBloc>(context).state.previewing || BlocProvider.of<TestBloc>(context).state.processing)) {
                      BlocProvider.of<TestBloc>(context).add(UpdateSettingsEvent(
                          tweenTime: value));
                    }
                },),
              ],),),
            ],
          ),
        ),

      ],
    );
  }
}

class Preview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TestState state = BlocProvider.of<TestBloc>(context).state;
    
    return Container(
      width: 256,
      height: 256,
      color: Colors.black,
      child: state.previewSignals.length == 0 || !state.previewing ? Container() : CustomPaint(
        painter: AngleSignalPainter(state.previewSignals[state.currentPreviewFrameIndex % state.previewSignals.length]),
      ),
    );
  }
  
}

class PreviewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HoverButton(body: Text("Preview", style: TextStyle(color: Colors.black)), color: Colors.lightBlue, hoverColor: Colors.lightBlueAccent, onPressed: (){
      BlocProvider.of<TestBloc>(context).add(StartPreviewEvent());
    });
  }
}

class CancelPreviewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HoverButton(body: Text("Stop Preview", style: TextStyle(color: Colors.black)), color: Colors.red, hoverColor: Colors.redAccent, onPressed: (){
      BlocProvider.of<TestBloc>(context).add(StopPreviewEvent());
    });
  }
}

class GenerateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HoverButton(body: Text("Generate Gif", style: TextStyle(color: Colors.black)), color: Colors.green, hoverColor: Colors.greenAccent, onPressed: (){
      BlocProvider.of<TestBloc>(context).add(InitiateProcessingEvent());
    });
  }
}

class CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HoverButton(body: Text("Cancel", style: TextStyle(color: Colors.black)), color: Colors.red, hoverColor: Colors.redAccent, onPressed: (){
      BlocProvider.of<TestBloc>(context).add(CancelProcessingEvent());
    });
  }
}


class SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HoverButton(body: Text("Save File", style: TextStyle(color: Colors.black)), color: Colors.amber, hoverColor: Colors.amberAccent, onPressed: (){
      FileSaver.instance.saveFile("Test", BlocProvider.of<TestBloc>(context).state.data!, "gif");
      print("Saved");
    });
  }
}

class CopyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HoverButton(body: Text("Copy to Clipboard", style: TextStyle(color: Colors.black)), color: Colors.teal, hoverColor: Colors.tealAccent, onPressed: (){});
  }
}

class HoverButton extends StatefulWidget {
  final Widget body;
  final Color color;
  final Color hoverColor;
  final void Function() onPressed;

  const HoverButton({required this.body, required this.color, required this.hoverColor, required this.onPressed, super.key});
  
  @override
  State<StatefulWidget> createState() => HoverButtonState();
  
}

class HoverButtonState extends State<HoverButton>
{
  bool hovering;
  
  HoverButtonState() : hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (details){
        setState(() {
          hovering = true;
        });
      },
      onExit: (details){
        setState(() {
          hovering = false;
        });
      },
      child: TextButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.zero),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black)),

        ),
        onPressed: widget.onPressed,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: hovering ? widget.hoverColor : widget.color,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Center(child: widget.body),),
        ),
      );
  }
  
}

class BlocTextField extends StatefulWidget {
  String defaultText;

  void Function(String) onChange;
  BlocTextField(this.defaultText, this.onChange);

  @override
  State<StatefulWidget> createState() => BlocTextFieldState();


}

class BlocTextFieldState extends State<BlocTextField> {
  TextEditingController controller;

  BlocTextFieldState() : controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.defaultText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: widget.onChange,
      enabled: !(BlocProvider.of<TestBloc>(context).state.processing || BlocProvider.of<TestBloc>(context).state.previewing),
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        label: Text("Text to Generate"),
        labelStyle: TextStyle(color: Colors.white70),
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.white, width: 1),
            gapPadding: 4),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.blue, width: 2),
            gapPadding: 4),
      ),
    );
  }
}