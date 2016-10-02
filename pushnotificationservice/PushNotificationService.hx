package pushnotificationservice;

import extensionkit.ExtensionKit;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class PushNotificationService {
	private static var pushnotificationservice_getPushID_jni : Dynamic;
	// private static var pushnotificationservice_getPushID : Dynamic; // for iOS

	public static var pushnotificationservice_firebaseInit_jni : Dynamic;

	private static var pushnotificationservice_initialize;
   //private static var pushnotifications_setcallback;

	public static function Initialize() : Void {
		try {
			#if android
				pushnotificationservice_getPushID_jni = JNI.createStaticMethod("org/haxe/extension/PushNotificationService", "getPushID", "()Ljava/lang/String;");
				pushnotificationservice_firebaseInit_jni = JNI.createStaticMethod("org/haxe/extension/PushNotificationService", "firebaseInit", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
			#end
			#if cpp
				// TODO iOS method
				pushnotificationservice_initialize = Lib.load ("pushnotificationservice", "pushnotificationservice_initialize", 0);
				//pushnotifications_setcallback = Lib.load("pushnotifications", "pushnotifications_setcallback", 1);
			#end
		} catch(e:Dynamic) {
			trace(e);
		}

		ExtensionKit.Initialize();
	}

	public static function getPushID() {
		#if android
			if (pushnotificationservice_getPushID_jni != null) {
				return pushnotificationservice_getPushID_jni();
			} else {
				trace("Error: PushNotificationService doesn't initialized");
				return "";
			}
		#elseif (cpp && mobile)
			// return pushnotificationservice_initialize();
			return null;
		#end
	}

	public static function messageServerInit(apiKey: String, appId: String, dbUrl: String, gcmSenderId: String, storageBucket: String) {
		#if android
				if (pushnotificationservice_firebaseInit_jni != null) {
					pushnotificationservice_firebaseInit_jni(apiKey, appId, dbUrl, gcmSenderId, storageBucket);
				} else {
					trace("Error: PushNotificationService doesn't initialized");
				}
		#elseif (cpp && mobile)
			pushnotificationservice_initialize();
		#end
	}
}