//
//  AppDelegate.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 29.07.24.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        requestNotificationAuthorization()
        
        // Set the language based on saved user preference
        let languageCode = UserDefaults.standard.string(forKey: "appLanguage") ?? Locale.current.language.languageCode?.identifier ?? "en"
        updateLanguage(to: languageCode)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged(_:)), name: .languageChanged, object: nil)
        
        return true
    }

    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("\(NSLocalizedString("errorRequestingAuthorization", comment: "Error requesting authorization")): \(error.localizedDescription)")
            } else if granted {
                print(NSLocalizedString("notificationAuthorizationGranted", comment: "Notification authorization granted"))
            } else {
                print(NSLocalizedString("notificationAuthorizationDenied", comment: "Notification authorization denied"))
            }
            
            self.checkNotificationSettings()
        }
    }
    
    func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                print(NSLocalizedString("notificationAuthorizationNotDetermined", comment: "Notification authorization not determined"))
            case .denied:
                print(NSLocalizedString("notificationAuthorizationDenied", comment: "Notification authorization denied"))
            case .authorized:
                print(NSLocalizedString("notificationAuthorizationGranted", comment: "Notification authorization granted"))
            case .provisional:
                print(NSLocalizedString("notificationAuthorizationProvisional", comment: "Notification authorization provisional"))
            case .ephemeral:
                print(NSLocalizedString("notificationAuthorizationEphemeral", comment: "Notification authorization ephemeral"))
            @unknown default:
                print(NSLocalizedString("notificationAuthorizationUnknown", comment: "Unknown notification authorization status"))
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    @objc func languageChanged(_ notification: Notification) {
        if let languageCode = notification.object as? String {
            updateLanguage(to: languageCode)
        }
    }
    
    func updateLanguage(to languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            window.makeKeyAndVisible()
        }
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

