//
//  NotificationHandler.swift
//  TranquilApp
//
//  Created by Victoria Reed on 2/23/23.
//

import Foundation
import UserNotifications

class NotificationHandler{
    func askPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.badge,.sound]){ success, error in
            if success{
                print("access granted!")
            } else if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(){
        var trigger: UNNotificationTrigger?
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "anxiety warning"
        content.body = "are you okay?"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "Softchime.m4r" ))
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    }
}
