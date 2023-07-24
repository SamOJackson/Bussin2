//
//  Notification.swift
//  Bussin
//
//  Created by Alexander Gullen on 2023-07-21.
//

import Foundation

import Firebase


class Notification{
    var id: String;
    
    var title: String = "";
    
    var message: String = "";
    
    var startDate: String = "";
    
    var endDate: String?;
    
    
    // single parameter initializer
    init(id: String){
        self.id = id;
        
    }
    
    // function to decode DataSnapshots from firebase into actual notifications
    public static func decodeDataSnapshot(dataSnapshot: DataSnapshot) -> Notification{
        
        // instanciate a new notification Item using the provided key
        let notification = Notification(id: dataSnapshot.key)
        
        // create a dictionary from the snapshot values then assign the values from that dictionary to the notification object
        if let dictionary = dataSnapshot.value as? [String:Any]{
            notification.title = dictionary["Title"] as! String;
            notification.message = dictionary["Message"] as! String;
            
            notification.startDate = dictionary["StartDate"] as! String;
            if let starDate = dictionary["EndDate"]{
                notification.endDate = dictionary["EndDate"] as! String;
            }
        }
        
        // return the notification
        return notification;
        
    }
    
    // outputs a string representing the object
    public func description() -> String {
        return """
        id=\(self.id)
        title=\(self.title)
        message=\(self.message)
        startDate=\(self.startDate)
        endDate=\(self.endDate)
        """;
    }
}


