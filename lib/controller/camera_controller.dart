
import 'dart:async';
import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

class CameraController{
  int countTouchesFlash = 0;
  int countTouchesRatio = 0;
  int countTouchesSensorPosition = 0;
  bool touchCamera = false;
  FlashMode flash = FlashMode.none;
  CameraAspectRatios ratio = CameraAspectRatios.ratio_4_3;
  SensorPosition sensorPosition = SensorPosition.back;
  StreamController streamCameraState = StreamController.broadcast();
  StreamController<File?> streamCapturePhoto = StreamController.broadcast();
  String? imagePath;
  File? photoCamera;

  void disposeStream() {
    streamCameraState.close();
    streamCapturePhoto.close();
  }

  void touchesFlash(CameraState? state) {
    countTouchesFlash++;
    if(countTouchesFlash == 1) {
      flash = FlashMode.auto;
      streamCameraState.sink.add(flash);
    } else if(countTouchesFlash == 2) {
      flash = FlashMode.on;
      streamCameraState.sink.add(flash);
    } else if(countTouchesFlash == 3) {
      flash = FlashMode.none;
      streamCameraState.sink.add(flash);
      countTouchesFlash = 0;
    }
    state?.sensorConfig.setFlashMode(flash);
  }

  void touchesRatio(CameraState? state) {
    countTouchesRatio++;
    if(countTouchesRatio == 1) {
      ratio = CameraAspectRatios.ratio_16_9;
      streamCameraState.sink.add(ratio);
    } else if(countTouchesRatio == 2) {
      ratio = CameraAspectRatios.ratio_1_1;
      streamCameraState.sink.add(ratio);
    } else if(countTouchesRatio == 3) {
      ratio = CameraAspectRatios.ratio_4_3;
      streamCameraState.sink.add(ratio);
      countTouchesRatio = 0;
    }
    state?.sensorConfig.setAspectRatio(ratio);
  }

  void touchesSensorPosition(CameraState? state) {
    countTouchesSensorPosition++;
    if(countTouchesSensorPosition == 1) {
      sensorPosition = SensorPosition.front;
      streamCameraState.sink.add(sensorPosition);
      flash = FlashMode.none;
      streamCameraState.sink.add(flash);
      ratio = CameraAspectRatios.ratio_4_3;
      streamCameraState.sink.add(ratio);
      countTouchesRatio = 0;
      countTouchesFlash = 0;
    } else if(countTouchesSensorPosition == 2){
      sensorPosition = SensorPosition.back;
      streamCameraState.sink.add(sensorPosition);
      flash = FlashMode.none;
      streamCameraState.sink.add(flash);
      ratio = CameraAspectRatios.ratio_4_3;
      streamCameraState.sink.add(ratio);
      countTouchesRatio = 0;
      countTouchesFlash = 0;
      countTouchesSensorPosition = 0;
    }
    state?.switchCameraSensor();
    state?.sensorConfig.setFlashMode(flash);
    state?.sensorConfig.setAspectRatio(ratio);
  }

  Future<void> clickTouchCamera(PhotoCameraState state, BuildContext context) async{
    if(touchCamera == false) {
      touchCamera = true;
      imagePath = (await state.takePhoto()).when(single: (single) => single.file?.path);
      photoCamera = File(imagePath!);
      touchCamera = false;
      streamCapturePhoto.sink.add(photoCamera);
    }
  }

  Future<void> repeatPhoto() async{
    photoCamera = null;
    if(photoCamera != null){
      if(await File(photoCamera!.path).exists()){
        await File(photoCamera!.path).delete();
      }
    }
    streamCapturePhoto.sink.add(photoCamera);
  }
}