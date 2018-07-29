//
//  Reminder.swift
//  BuildHabit
//
//  Created by Admin on 6/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//
import Foundation
import UIKit
import UserNotifications
import FileProvider

class Reminder: NSObject,NSCoding{

    
    //Properies
    var notification: UNNotificationRequest
    var name: String
    var time: NSDate
    
    //Archive paths for Persistent Data
    
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("reminders")
    
    //enum for property keys
    
    struct PropertyKey {
        static let nameKey = "name"
        static let timeKey = "time"
        static let notificationKey = "notification"
    }
    
    //Initializer
    
    init(name: String, time: NSDate, notification: UNNotificationRequest){
        self.name = name
        self.time = time
        self.notification = notification
        super.init()
    }
 
 
    
    // Destructor
    deinit{
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.notification.identifier])
    }
    
    // NSCoding
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(time, forKey: PropertyKey.timeKey)
        aCoder.encode(notification, forKey: PropertyKey.notificationKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey)
        let time = aDecoder.decodeObject(forKey: PropertyKey.timeKey)
        let notification = aDecoder.decodeObject(forKey: PropertyKey.notificationKey)
        
        self.init(name: name as! String, time: time as! NSDate, notification: notification as! UNNotificationRequest)
    }
    
    
    
    
}
