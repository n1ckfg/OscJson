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
    OscMessage myMessage;
  
    myMessage = new OscMessage("/" + msg.channel);
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

class OscJson {
  
  String url = "";
  ArrayList<OscJsonMsg> msgs;
  JSONObject json;
  JSONObject jsonMsg;
  JSONObject jsonArg;
  
  OscJson(String _url) {
    init(_url);
  }
  
  OscJsonMsg getMsg(String _channel) {
    for (int i=0; i<msgs.size(); i++) {
       OscJsonMsg msg = msgs.get(i);
      if (msg.channel == _channel) {
        return msg;
      }
    }
    return null;
  }
  
  ArrayList<OscJsonArg> getArgs(String _channel) {
    return getMsg(_channel).args;
  }
  
  boolean getMatch(String _channel, String _typetag) {
    if (getMsg(_channel).typetag == _typetag) {
      return true;
    } else {
      return false;
    }
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
        OscJsonArg arg = new OscJsonArg(jsonArg.getString("id"), jsonArg.getString("type"));
        msg.addArg(arg);
      }
      
      msgs.add(msg);
    }
  }
  
}

class OscJsonMsg {
  
  ArrayList<OscJsonArg> args;
  String typetag;
  String channel;
  
  OscJsonMsg(String _channel) {
    channel = _channel;
    args = new ArrayList<OscJsonArg>();
    
    // TODO build arg list, assign channel and typetag
  }
  
  void addArg(OscJsonArg arg) {
    typetag += arg.type;
    args.add(arg);
  }
  
}

class OscJsonArg {
  
  String s;
  int i;
  float f;
  //byte[] b;
  
  String type;
  String id;
  
  OscJsonArg(String _id, String _type) {
    id = _id;
    type = _type;
  }
    
}
