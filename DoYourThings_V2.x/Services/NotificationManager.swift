//
//  NotificationManager.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 29.07.24.
//

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
}
