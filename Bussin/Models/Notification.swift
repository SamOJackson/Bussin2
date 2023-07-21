//
//  Notification.swift
//  Bussin
//
//  Created by Alexander Gullen on 2023-07-21.
//

import Foundation


class Notification{
    var id: String;
    
    var title: String = "";
    
    var message: String = "";
    
    var startDate: Date = Date();
    
    var endDate: Date?;
    
    
    init(id: String){
        self.id = id;
        
    }
    
    init(id: String, title: String, message: String, startDate: Date, endDate: Date) {
        self.id = id;
        self.title = title;
        self.message = message;
        self.startDate = startDate;
        self.endDate = endDate;
    }
    
    init(id: String, title: String, message: String, startDate: Date) {
        self.id = id;
        self.title = title;
        self.message = message;
        self.startDate = startDate;
    }
}


