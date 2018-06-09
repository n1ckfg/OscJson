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
