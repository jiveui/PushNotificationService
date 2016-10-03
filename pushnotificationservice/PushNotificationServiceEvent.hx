package pushnotificationservice;

import flash.events.Event;


class PushNotificationServiceEvent extends Event {
    public static inline var REFRESH_TOKEN = "refresh_token";
    public static inline var MESSAGE_RECEIVED = "message_received";

    public var token(default, null) : String = null;
    public var receivedMeassage(default, null) : String = null;

    public function new(type: String, token: String, receivedMessage: String = "") {
        super(type, true, true);

        this.token = token;
        this.receivedMeassage = receivedMeassage;
    }

    public override function clone() : Event {
        return new PushNotificationServiceEvent(type, token, receivedMeassage);
    }

    public override function toString() : String {
        var s = "[PushNotificationServiceEvent type=" + type;
        s += " token=" + token;
        s += "receivedMeassage" + receivedMeassage;
        s += "]";
        return s;
    }
}
