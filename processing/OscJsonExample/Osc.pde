import oscP5.*;
import netP5.*;

String ipNumber = "127.0.0.1";
int sendPort = 7110;
int receivePort = 9999;
OscP5 oscP5;
NetAddress myRemoteLocation;

void oscSetup() {
  oscP5 = new OscP5(this, receivePort);
  myRemoteLocation = new NetAddress(ipNumber, sendPort);
  //oscP5.plug(this, "parseOsc", "/pos");
}

// Send message example
void sendOsc() {
  OscMessage myMessage;

  myMessage = new OscMessage("/test");
  myMessage.add("testData");
  oscP5.send(myMessage, myRemoteLocation);
} 

// Receive message example
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/pos") && msg.checkTypetag("ffi")) {
    println("OSC");
    float x = msg.get(0).floatValue();
    float y = msg.get(1).floatValue();
    int b = msg.get(2).intValue();
    player1.deltaPos = new PVector(x, y);
    if (b == 0&& player1.trigger) {
      player1.stopFiring();
    } else if (b == 1 && !player1.trigger) {
      player1.startFiring();
    }
  }
  println("eee");
}


/*
void parseOsc(float x, float y, int b) {
  println("OSC");
  player1.deltaPos = new PVector(x, y);
  if (b == 0&& player1.trigger) {
    player1.stopFiring();
  } else if (b == 1 && !player1.trigger) {
    player1.startFiring();
  }
}
*/