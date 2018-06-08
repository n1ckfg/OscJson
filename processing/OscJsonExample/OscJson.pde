// http://opensoundcontrol.org/spec-1_0

class OscJson {
  
  ArrayList<OscJsonMsg> receiveMsg;
  ArrayList<OscJsonMsg> sendMsg;
  
  OscJson() {
    receiveMsg = new ArrayList<OscJsonMsg>();
    sendMsg = new ArrayList<OscJsonMsg>();  
  }
  
  void loadSendTemplate() {
    //
  }
  
  void loadReceiveTemplate() {
    //
  }
  
  void sendOsc() {
    // 
  }
  
  void receiveOsc() {
    //
  }
  
}

class OscJsonMsg {
  
  ArrayList<OscJsonArg> args;
  String typetag;
  String channel;
  
  OscJsonMsg() {
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
  
  OscJsonArg(String _s) {
    s = _s;
    type = "s";
  }
  
  OscJsonArg(int _i) {
    i = _i;
    type = "i";
  }
  
  OscJsonArg(float _f) {
    f = _f;
    type = "f";
  }
    
}
