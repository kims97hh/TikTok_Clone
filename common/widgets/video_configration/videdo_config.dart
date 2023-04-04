import 'package:flutter/material.dart';

// InheritedWidget{} + StatefulWidget{}) 의 조합은 전체 widget에 데이터 공유시 사용한다. 단, 전체 Widget를 rebuild 하므로 비효율적이다.
// ChangeNotifier{} + AnimateBuilder() 의 조합은 필요한 곳만 데이터 공유가 가능하고, 해당 method만 rebuild 한다. 다량의 데이터 와 함께 사용시 고효율
// 더불어, notifyListeners(); + .addListener(); 를 함께 사용하여 데이터 공유한다. - notifyListener 는 hub, .addListener는 각clinent로 이해한다.
// valueChangenotifier()  단한개, 데이터 공유시 사용 데이터 수신방법은 ChangeNotifier{} 와 같이 AnimateBuilder(), notifyListener, .addListener 를 사용한다.

//예제***
/* class VideoConfig extends ChangeNotifier { 
  bool autoMute = true;

  void toggleAutoMute() {
    autoMute = !autoMute;
    notifyListeners(); // ChangeNotifier{} 에서 setState{} 와 같은 역할, 리스너필수
  }
}

final videoConfig = VideoConfig();
 */

final darkMode = ValueNotifier(false); //오직 1개의 값만 반환한다.

class VideoConfig extends ChangeNotifier {
  bool isMuted = false;
  bool isAutoplay = false;

  void toggleIsMuted() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleIsAutoplay() {
    isAutoplay = !isAutoplay;
    notifyListeners();
  }
}
