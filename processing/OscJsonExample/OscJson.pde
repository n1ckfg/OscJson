import oscP5.*;
import netP5.*;

OscJson oscJson;
String configUrl = "osc-format.json";
String ipNumber = "127.0.0.1";
int sendPort = 9998;
int receivePort = 9999;
OscP5 oscP5;
NetAddress myRemoteLocation;

void oscSetup() {
  oscP5 = new OscP5(this, receivePort);
  myRemoteLocation = new NetAddress(ipNumber, sendPort);

  oscJson = new OscJson(configUrl);
}

// Send message example
void oscSend() {
  for (int i=0; i<oscJson.msgs.size(); i++) {
    OscJsonMsg msg = oscJson.msgs.get(i);
    OscMessage myMessage = new OscMessage("/" + msg.channel);
    for (int j=0; j<msg.args.size(); j++) {
      OscJsonArg arg = msg.args.get(j);
      myMessage.add(arg.id);
    }
    
    oscP5.send(myMessage, myRemoteLocation);
  }
} 

// Receive message example
void oscEvent(OscMessage msg) {
  /*
  if (msg.checkAddrPattern("/pos") && msg.checkTypetag("ffi")) {
    float x = msg.get(0).floatValue();
    float y = msg.get(1).floatValue();
    int b = msg.get(2).intValue();
  }
  */
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

// http://opensoundcontrol.org/spec-1_0

class OscParam {

  String id;
  String type;
  
  String s;
  int i;
  float f;
  byte[] b;
  
  OscParam(String _id, Object o) {
    id = _id;
    setData(o);
  }
  
  void setData(Object o) {
    if (o instanceof String) {
      s = (String) o;
      type = "s";
    } else if (o instanceof Integer) {
      i = (int) o;
      type = "i";
    } else if (o instanceof Float) {
      f = (float) o;
      type = "f";
    } else if (o instanceof Byte[]) {
      b = (byte[]) o;
      type = "b";
    }
  }
  
  Object getData() {
    Object returns = null;
    switch(type) {
      case("s"):
        returns = (Object) s;
        break;
      case("i"):
        returns = (Object) i;
        break;
      case("f"):
        returns = (Object) f;
        break;
      case("b"):
        returns = (Object) b;
        break;
    }
    return returns;
  }
  
}

class OscJson {
  
  String url = "";
  ArrayList<OscJsonMsg> msgs;
  JSONObject json;
  JSONObject jsonMsg;
  JSONObject jsonArg;
  
  OscJson(String _url) {
    init(_url);
  }
   
  void init(String _url) {
    url = _url;
    msgs = new ArrayList<OscJsonMsg>();
    
    json = loadJSONObject(url);
    for (int i=0; i<json.getJSONArray("messages").size(); i++) {
      jsonMsg = (JSONObject) json.getJSONArray("messages").get(i);
      OscJsonMsg msg = new OscJsonMsg(jsonMsg.getString("channel"));
      
      for (int j=0; j<jsonMsg.getJSONArray("arguments").size(); j++) {
        jsonArg = (JSONObject) jsonMsg.getJSONArray("arguments").get(j);
        try {
          OscJsonArg arg = new OscJsonArg(jsonArg.getString("id"), jsonArg.getString("type"));
          msg.args.add(arg);
        } catch (Exception e) { }
      }
      
      println("channel: " + msg.channel + "   typetag: " + msg.getTypetag());
      msgs.add(msg);
    }
  }
  
}

class OscJsonMsg {
  
  ArrayList<OscJsonArg> args;
  String channel;
  
  OscJsonMsg(String _channel) {
    channel = _channel;
    args = new ArrayList<OscJsonArg>();    
  }

  String getTypetag() {
    String returns = "";
    for (int i=0; i<args.size(); i++) {
      returns += args.get(i).type;
    }
    return returns;
  }

}

class OscJsonArg {
  
  String type;
  String id;
  
  OscJsonArg(String _id, String _type) {
    id = _id;
    type = _type;
  }
    
}
