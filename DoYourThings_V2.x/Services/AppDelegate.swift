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
        
        return true
    }

    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
            } else if granted {
                print("Notification authorization granted.")
            } else {
                print("Notification authorization denied.")
            }
            
            self.checkNotificationSettings()
        }
    }
    
    func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                print("Benachrichtigungsberechtigung nicht erteilt")
            case .denied:
                print("Benachrichtigungsberechtigung abgelehnt")
            case .authorized:
                print("Benachrichtigungsberechtigung erteilt")
            case .provisional:
                print("Provisorische Benachrichtigungsberechtigung erteilt")
            case .ephemeral:
                print("Ephemere Benachrichtigungsberechtigung erteilt")
            @unknown default:
                print("Unbekannter Benachrichtigungsstatus")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
