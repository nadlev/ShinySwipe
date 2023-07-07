//
//  AppDelegate.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//
import UIKit
import AppTrackingTransparency
import AppsFlyerLib
import AdSupport
import FBSDKCoreKit
import FirebaseCore
import FirebaseAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var identifierAdvertising: String = ""
    var tokenPushNotification: String = ""
    
    var timeZoneAbbreviationLocal: String {
        return TimeZone.current.abbreviation() ?? ""
    }

    let codeLanguageLocalized = NSLocale.current.languageCode
    
    func timeZoneCurrent() -> String {
        return TimeZone.current.identifier
    }
    var oldAndNotWorkingNames: [String : Any] = [:]
    var dataAttribution: [String : Any] = [:]
    var deepLinkParameterFB: String = ""
    var uniqueIdentifierAppsFlyer: String = ""

    let pushNotificationJoo = JooPush()
    var subject1 = ""
    var subject2 = ""
    var subject3 = ""
    var subject5 = ""
    var oneLinkDeepLink = ""
    
    var applicationLocalized: String = ""
    
    var geographicalNameTimeZone: String = ""
    var abbreviationTimeZone: String = ""
    
    var subject4 = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        geographicalNameTimeZone = timeZoneCurrent()
        abbreviationTimeZone = timeZoneAbbreviationLocal
        applicationLocalized = codeLanguageLocalized ?? ""
        
        pushNotificationJoo.notificationCenter.delegate = pushNotificationJoo
        pushNotificationJoo.requestAutorization()
        
        AppsFlyerLib.shared().appsFlyerDevKey = "LbSAnvCDRqtFBTGvL9i8dV"
        AppsFlyerLib.shared().appleAppID = "6450709854"
        AppsFlyerLib.shared().deepLinkDelegate = self
        AppsFlyerLib.shared().delegate = self
        uniqueIdentifierAppsFlyer = AppsFlyerLib.shared().getAppsFlyerUID()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.createFacebook()
        self.createGoogleFirebase()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
                let yourWebConnector = MenuStart()
                self.window?.rootViewController = yourWebConnector
                self.window?.makeKeyAndVisible()
        
        return true
        
    }
    
    func createFacebook() {
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            if let error = error {
                print("Received error while fetching deferred app link %@", error)
            }
            if let url = url {
                self.deepLinkParameterFB = url.absoluteString
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func createGoogleFirebase() {
        FirebaseApp.configure()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14, *) {
            AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .authorized:
                    print("Authorized")
                    self.identifierAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    Settings.shared.isAdvertiserTrackingEnabled = true
                case .denied:
                    print("Denied")
                    self.identifierAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                case .notDetermined:
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }

                DispatchQueue.main.async {
                    if let rootViewController = self.window?.rootViewController as? MenuStart {
                        rootViewController.startToRequest()
                    }
                }
            }
        } else {
            self.identifierAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            DispatchQueue.main.async {
                if self.window?.rootViewController is MenuStart {
                    //rootViewController.startToRequest()
                }
            }
        }
        AppsFlyerLib.shared().start()
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        
        return true
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                               annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
                AppsFlyerLib.shared().handlePushNotification(userInfo)
           }
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            
            let tokenParts = deviceToken.map { data -> String in
                return String(format: "%02.2hhx", data)
            }
            
            let token = tokenParts.joined()
            print("Device token: \(token)")
            tokenPushNotification = token
        }
        
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            
            print("Failed to register: \(error)")
        }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DispatchQueue.main.async {
            (self.window!.rootViewController as? YourWebConnector)?.jooLastUrl()
            print("TAPPPED")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        DispatchQueue.main.async {
            (self.window!.rootViewController as? YourWebConnector)?.jooLastUrl()
            print("TAPPPED")
        }
    }
}

//MARK: AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate{
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        oldAndNotWorkingNames = installData as! [String : Any]
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    print("////////////////////////////////////////////////////////This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)////////////////////////////////////////////////////////")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
               is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    func onConversionDataFail(_ error: Error) {
        print(error)
    }
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        self.dataAttribution = attributionData as! [String : Any]
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
    }
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
    }
}

extension AppDelegate: DeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .notFound:
            NSLog("////////////////////////////////////////////////////////[AFSDK] Deep link not found////////////////////////////////////////////////////////")
            return
        case .failure:
            print("Error %@", result.error!)
            return
        case .found:
            NSLog("[AFSDK] Deep link found")
        }
        
        guard let deepLinkObj:DeepLink = result.deepLink else {
            NSLog("[AFSDK] Could not extract deep link object")
            return
        }
        
        if deepLinkObj.clickEvent.keys.contains("deep_link_sub2") {
            let ReferrerId:String = deepLinkObj.clickEvent["deep_link_sub2"] as! String
            NSLog("[AFSDK] AppsFlyer: Referrer ID: \(ReferrerId)")
            self.subject2 = ReferrerId
        } else {
            NSLog("[AFSDK] Could not extract referrerId")
        }
        
        if deepLinkObj.clickEvent.keys.contains("deep_link_sub3") {
            let ReferrerId:String = deepLinkObj.clickEvent["deep_link_sub3"] as! String
            NSLog("[AFSDK] AppsFlyer: Referrer ID: \(ReferrerId)")
            self.subject3 = ReferrerId
        } else {
            NSLog("[AFSDK] Could not extract referrerId")
        }
        
        if deepLinkObj.clickEvent.keys.contains("deep_link_sub4") {
            let ReferrerId:String = deepLinkObj.clickEvent["deep_link_sub4"] as! String
            NSLog("[AFSDK] AppsFlyer: Referrer ID: \(ReferrerId)")
            self.subject4 = ReferrerId
        } else {
            NSLog("[AFSDK] Could not extract referrerId")
        }
        
        if deepLinkObj.clickEvent.keys.contains("deep_link_sub5") {
            let ReferrerId:String = deepLinkObj.clickEvent["deep_link_sub5"] as! String
            NSLog("[AFSDK] AppsFlyer: Referrer ID: \(ReferrerId)")
            self.subject5 = ReferrerId
        } else {
            NSLog("[AFSDK] Could not extract referrerId")
        }
        if deepLinkObj.clickEvent.keys.contains("deep_link_sub1") {
            let ReferrerId:String = deepLinkObj.clickEvent["deep_link_sub1"] as! String
            NSLog("[AFSDK] AppsFlyer: Referrer ID: \(ReferrerId)")
            self.subject1 = ReferrerId
        } else {
            NSLog("[AFSDK] Could not extract referrerId")
        }
        
        let deepLinkStr:String = deepLinkObj.toString()
        NSLog("[AFSDK] DeepLink data is: \(deepLinkStr)")
        self.oneLinkDeepLink = deepLinkStr
        if (deepLinkObj.isDeferred == true) {
            NSLog("[AFSDK] This is a deferred deep link")
        }
        else {
            NSLog("[AFSDK] This is a direct deep link")
        }
    }
}
