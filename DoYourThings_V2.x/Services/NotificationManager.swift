//
//  NotificationManager.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 29.07.24.
//

/*import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
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
    
    private func checkNotificationSettings() {
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
    
    func scheduleNotification(task: DoYourThing, isReminder: Bool) {
        let content = UNMutableNotificationContent()
        content.title = isReminder ? "Reminder: \(task.dytTitel)" : "Deadline: \(task.dytTitel)"
        content.body = "Priorität: \(task.dytPriority) - Kategorie: \(task.dytCategory)\nDetails: \(task.dytDetailtext)"
        content.sound = UNNotificationSound.default
        content.userInfo = ["taskId": task.id.uuidString]
        
        var triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: isReminder ? task.dytAlarmReminderDate : task.dytAlarmDeadlineDate)
        let triggerTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: isReminder ? task.dytAlarmReminderTime : task.dytAlarmDeadlineTime)
        triggerDateComponents.hour = triggerTimeComponents.hour
        triggerDateComponents.minute = triggerTimeComponents.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString + (isReminder ? "_reminder" : "_deadline"), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(isReminder ? task.dytAlarmReminderDate : task.dytAlarmDeadlineDate) at \(isReminder ? task.dytAlarmReminderTime : task.dytAlarmDeadlineTime)")
            }
        }
    }

    func removeNotification(task: DoYourThing) {
        let identifiers = [task.id.uuidString + "_reminder", task.id.uuidString + "_deadline"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}*/

/*import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
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
    
    private func checkNotificationSettings() {
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
    
    func scheduleNotification(task: DoYourThing, isReminder: Bool) {
        let content = UNMutableNotificationContent()
        content.title = isReminder ? String(format: NSLocalizedString("reminderTitle", comment: "Reminder: %@"), task.dytTitel) : String(format: NSLocalizedString("deadlineTitle", comment: "Deadline: %@"), task.dytTitel)
        
        let localizedPriority = localizedPriority(for: task.dytPriority)
        
        content.body = String(format: NSLocalizedString("notificationBody", comment: "Priority: %@ - Category: %@\nDetails: %@"), localizedPriority, task.dytCategory, task.dytDetailtext)
        content.sound = UNNotificationSound.default
        content.userInfo = ["taskId": task.id.uuidString]
        
        var triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: isReminder ? task.dytAlarmReminderDate : task.dytAlarmDeadlineDate)
        let triggerTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: isReminder ? task.dytAlarmReminderTime : task.dytAlarmDeadlineTime)
        triggerDateComponents.hour = triggerTimeComponents.hour
        triggerDateComponents.minute = triggerTimeComponents.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString + (isReminder ? "_reminder" : "_deadline"), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("\(NSLocalizedString("errorSchedulingNotification", comment: "Error scheduling notification")): \(error.localizedDescription)")
            } else {
                let date = isReminder ? task.dytAlarmReminderDate : task.dytAlarmDeadlineDate
                let time = isReminder ? task.dytAlarmReminderTime : task.dytAlarmDeadlineTime
                print(String(format: NSLocalizedString("notificationScheduled", comment: "Notification scheduled for %@ at %@"), "\(date)", "\(time)"))
            }
        }
    }

    private func localizedPriority(for priority: String) -> String {
        switch priority {
        case "Sehr Hoch":
            return NSLocalizedString("veryHigh", comment: "Very High")
        case "Hoch":
            return NSLocalizedString("high", comment: "High")
        case "Mittel":
            return NSLocalizedString("medium", comment: "Medium")
        case "Niedrig":
            return NSLocalizedString("low", comment: "Low")
        case "Sehr Niedrig":
            return NSLocalizedString("veryLow", comment: "Very Low")
        default:
            return priority
        }
    }

    func removeNotification(task: DoYourThing) {
        let identifiers = [task.id.uuidString + "_reminder", task.id.uuidString + "_deadline"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}*/

import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
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
    
    private func checkNotificationSettings() {
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
    
    func scheduleNotification(task: DoYourThing, isReminder: Bool) {
        let content = UNMutableNotificationContent()
        content.title = isReminder ? String(format: NSLocalizedString("reminderTitle", comment: "Reminder: %@"), task.dytTitel) : String(format: NSLocalizedString("deadlineTitle", comment: "Deadline: %@"), task.dytTitel)
        
        let localizedPriority = localizedPriority(for: task.dytPriority)
        let localizedCategory = localizedCategory(for: task.dytCategory)
        
        content.body = String(format: NSLocalizedString("notificationBody", comment: "Priority: %@ - Category: %@\nDetails: %@"), localizedPriority, localizedCategory, task.dytDetailtext)
        content.sound = UNNotificationSound.default
        content.userInfo = ["taskId": task.id.uuidString]
        
        var triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: isReminder ? task.dytAlarmReminderDate : task.dytAlarmDeadlineDate)
        let triggerTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: isReminder ? task.dytAlarmReminderTime : task.dytAlarmDeadlineTime)
        triggerDateComponents.hour = triggerTimeComponents.hour
        triggerDateComponents.minute = triggerTimeComponents.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString + (isReminder ? "_reminder" : "_deadline"), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("\(NSLocalizedString("errorSchedulingNotification", comment: "Error scheduling notification")): \(error.localizedDescription)")
            } else {
                let date = isReminder ? task.dytAlarmReminderDate : task.dytAlarmDeadlineDate
                let time = isReminder ? task.dytAlarmReminderTime : task.dytAlarmDeadlineTime
                print(String(format: NSLocalizedString("notificationScheduled", comment: "Notification scheduled for %@ at %@"), "\(date)", "\(time)"))
            }
        }
    }

    private func localizedPriority(for priority: String) -> String {
        switch priority {
        case "Sehr Hoch":
            return NSLocalizedString("veryHigh", comment: "Very High")
        case "Hoch":
            return NSLocalizedString("high", comment: "High")
        case "Mittel":
            return NSLocalizedString("medium", comment: "Medium")
        case "Niedrig":
            return NSLocalizedString("low", comment: "Low")
        case "Sehr Niedrig":
            return NSLocalizedString("veryLow", comment: "Very Low")
        default:
            return priority
        }
    }
    
    private func localizedCategory(for category: String) -> String {
        let categories = DoYourThingViewModel.shared.categories
        if let categoryObj = categories.first(where: { $0.originalName == category || $0.name == category }) {
            return categoryObj.name
        }
        return category
    }

    func removeNotification(task: DoYourThing) {
        let identifiers = [task.id.uuidString + "_reminder", task.id.uuidString + "_deadline"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
