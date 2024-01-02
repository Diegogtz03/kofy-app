//
//  NotificationManager.swift
//  Kofy
//
//  Created by Diego Gutierrez on 28/11/23.
//

import UserNotifications
import Foundation
import SwiftUI

class NotificationManager {
    static let shared = NotificationManager()

    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting authorization for notifications: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotification(title: String, body: String, expirationDate: Date, secondWait: Double, toast: Binding<Toast?>) -> String {
        requestNotificationAuthorization()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName("notification.wav"))
        content.interruptionLevel = UNNotificationInterruptionLevel(rawValue: 2)!
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondWait, repeats: true)
        
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
                toast.wrappedValue = Toast(style: .error, appearPosition: .top, message: "Error registrando recordatorio", topOffset: 0)
            }
        }
        
        toast.wrappedValue = Toast(style: .success, appearPosition: .top, message: "Recordatorio agregado exitosamente", topOffset: 0)
        
        return identifier
    }

    func removeExpiredNotifications() {
        notificationCenter.getPendingNotificationRequests { requests in
            let expiredRequests = requests.filter { request in
                guard let trigger = request.trigger as? UNTimeIntervalNotificationTrigger else { return false }
                return Date().timeIntervalSince1970 > trigger.nextTriggerDate()?.timeIntervalSince1970 ?? 0
            }

            let identifiers = expiredRequests.map { $0.identifier }
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func deleteNotification(with identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
