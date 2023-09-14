import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:meus_contatos/controller/camera_controller.dart';

class CameraPage extends StatefulWidget {
  File? photoCamera;
  CameraPage({super.key, required this.photoCamera});
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController _controller = CameraController();

  @override
  void dispose() {
    _controller.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<File?>(
      stream: _controller.streamCapturePhoto.stream,
      initialData: null,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: snapshot.data != null ? layoutImageCaptured(snapshot) : AspectRatio(
            aspectRatio: MediaQuery.of(context).size.width/MediaQuery.of(context).size.height,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CameraAwesomeBuilder.custom(
                previewFit: CameraPreviewFit.contain,
                builder: (cameraState, previewSize, previewRect) {
                  return cameraState.when(
                    onPreparingCamera: (state) => const Center(child: CircularProgressIndicator(color: Colors.purple)),
                    onPhotoMode: (state) => layoutCamera(state),
                  );
                },
                theme: AwesomeTheme(
                  bottomActionsBackgroundColor: Colors.black,
                  buttonTheme: AwesomeButtonTheme(
                    backgroundColor: Colors.black,
                    iconSize: 32,
                  ),
                ),
                saveConfig: SaveConfig.photo(),
                sensorConfig: SensorConfig.single(
                  aspectRatio: _controller.ratio,
                  flashMode: _controller.flash,
                  sensor: Sensor.position(_controller.sensorPosition),
                  zoom: 0.0, 
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget layoutCamera(state){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder(
                  stream: _controller.streamCameraState.stream,
                  builder: (context, snapshot) {
                    return InkWell(
                      onTap:() => _controller.touchesFlash(state),
                      child: CircleAvatar(
                        maxRadius: 26,
                        backgroundColor: Colors.grey[900],
                        child: iconFlash()
                      ),
                    );
                  }
                ),
                StreamBuilder(
                  stream: _controller.streamCameraState.stream,
                  builder: (context, snapshot) {
                    return InkWell(
                      onTap: () => _controller.touchesRatio(state),
                      child: CircleAvatar(
                        maxRadius: 26,
                        backgroundColor: Colors.grey[900],
                        child: textRatio()
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Row(                  
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                    maxRadius: 26,
                    backgroundColor: Colors.transparent,
                  ),
                InkWell(
                  splashColor: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  onTap: () async => await _controller.clickTouchCamera(state, context),
                  child: buttonCamera(),
                ),
                StreamBuilder(
                  stream: _controller.streamCameraState.stream,
                  builder: (context, snapshot) {
                    return InkWell(
                      onTap: () => _controller.touchesSensorPosition(state),
                      child: CircleAvatar(
                        maxRadius: 26,
                        backgroundColor: Colors.grey[900],
                        child: iconSensor(),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget layoutImageCaptured(AsyncSnapshot snapshot) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(),
                Image.file(snapshot.data!),
              ]
            ),
          ),
        ),
        Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 64),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _controller.repeatPhoto(),
                  child: Text("Repetir", style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                TextButton(
                  onPressed: () {
                    widget.photoCamera = snapshot.data;
                    Navigator.pop(context, snapshot.data);
                  },
                  child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget iconFlash() {
    if(_controller.flash == FlashMode.none){
      return AwesomeOrientedWidget(
        child: Icon(Icons.flash_off, color: Colors.white),
        rotateWithDevice: true,
      );
    } else if(_controller.flash == FlashMode.auto) {
      return AwesomeOrientedWidget(
        child: Icon(Icons.flash_auto, color: Colors.white),
        rotateWithDevice: true,
      );
    } else{
      return AwesomeOrientedWidget(
        child: Icon(Icons.flash_on, color: Colors.white),
        rotateWithDevice: true,
      );
    }
  }

  Widget textRatio() {
    if(_controller.ratio == CameraAspectRatios.ratio_4_3){
      return AwesomeOrientedWidget(
        child: Text("3:4", style: TextStyle(color: Colors.white, fontSize: 22)),
        rotateWithDevice: true,
      );
    } else if(_controller.ratio == CameraAspectRatios.ratio_16_9) {
      return AwesomeOrientedWidget(
        child: Text("9:16", style: TextStyle(color: Colors.white, fontSize: 22)),
        rotateWithDevice: true,
      );
    } else{
      return AwesomeOrientedWidget(
        child: Text("1:1", style: TextStyle(color: Colors.white, fontSize: 22)),
        rotateWithDevice: true,
      );
    }
  }

  Widget iconSensor() {
    if(_controller.sensorPosition == SensorPosition.back) {
      return AwesomeOrientedWidget(
        child: Icon(Icons.camera_front, color: Colors.white, size: 30),
        rotateWithDevice: true,
      );
    } else {
      return AwesomeOrientedWidget(
        child: Icon(Icons.camera_rear, color: Colors.white, size: 30),
        rotateWithDevice: true,
      );
    }
  }

  Widget buttonCamera() {
    return CircleAvatar(
      maxRadius: 40,
      backgroundColor: Colors.grey,
      child: CircleAvatar(
        maxRadius: 36,
        backgroundColor: Colors.white,
      ),
    );
  }
}
