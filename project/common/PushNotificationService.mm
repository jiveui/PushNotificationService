#include "Utils.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>


#include "ExtensionKitIPhone.h"
#include "Utils.h"

@interface PushNotifications:NSObject
@end

@interface NMEAppDelegate : NSObject <UIApplicationDelegate>
@end
@interface NMEAppDelegate (PushNotifications)
    @property (nonatomic, retain) id pushNotif;
@end

static char const * const PushNotifKey = "pushnotifications";
static char g_buffer[2048];

@implementation NMEAppDelegate (PushNotifications)
@dynamic pushNotif;
    - (id)pushNotif
    {
        return objc_getAssociatedObject(self, PushNotifKey);
    }

    - (void)setPushNotif:(id)newPushNotif
    {
        objc_setAssociatedObject(self, PushNotifKey, newPushNotif, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    // - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
    // {
       

    //    return YES;
    // }


    - (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
    {
        NSLog(@"didRegister");
        NSLog(@"My token is: %@", deviceToken);

        NSString *token = [[[[deviceToken description]
                    stringByReplacingOccurrencesOfString: @"<" withString: @""] 
                    stringByReplacingOccurrencesOfString: @">" withString: @""] 
                    stringByReplacingOccurrencesOfString: @" " withString: @""];;

        [token getCString:g_buffer maxLength:sizeof(g_buffer)/sizeof(*g_buffer) encoding:NSUTF8StringEncoding];

        extensionkit::DispatchEventToHaxe("pushnotificationservice.PushNotificationServiceEvent",
              extensionkit::CSTRING, "refresh_token",
              extensionkit::CSTRING, g_buffer,
              extensionkit::CEND);

    }

    -(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
    {
        NSLog(@"didReceiveRemoteNotification");

        NSString *msg = [NSString stringWithFormat:@"Your App name received this notification while it was running:\n%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];

        NSLog(@"%@", msg);

        [msg getCString:g_buffer maxLength:sizeof(g_buffer)/sizeof(*g_buffer) encoding:NSUTF8StringEncoding];

        extensionkit::DispatchEventToHaxe("pushnotificationservice.PushNotificationServiceEvent",
              extensionkit::CSTRING, "message_received",
              extensionkit::CSTRING, "",
              extensionkit::CSTRING, g_buffer,
              extensionkit::CEND);

         // HaxeCallback.DispatchEventToHaxe("pushnotificationservice.PushNotificationServiceEvent",
         //            new Object[]{
         //                    "message_received",
         //                    "",
         //                    remoteMessage.getNotification().getBody()
         //            }
         //    );
    }


    - (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
    {
        NSLog(@"Failed to get token, error: %@", error);
    }
@end


@implementation PushNotifications
- (id)init
    {
        NSLog(@"Init");
        return self;
    }

    - (void)register
    {
        // [[UIApplication sharedApplication]
        //     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
        // [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

        // iOS 8 Notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];

        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
@end



namespace pushnotificationservice
{
    PushNotifications* push;
    void Initialize()
    {
        push = [[PushNotifications alloc] init];
        NMEAppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app setPushNotif:push];
        [push register];

        // NSString *token = [app token];

        // [token getCString:g_buffer maxLength:sizeof(g_buffer)/sizeof(*g_buffer) encoding:NSUTF8StringEncoding];
        // return g_buffer

    }

}
