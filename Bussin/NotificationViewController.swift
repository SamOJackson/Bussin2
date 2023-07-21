//
//  NotificationViewController.swift
//  Bussin
//
//  Created by Alexander Gullen on 2023-07-20.
//

import UIKit

import Firebase


class NotificationViewController: UIViewController {
    
    
    var databaseReference: DatabaseReference!;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseReference = Database.database().reference();
        /*
        //code to access database
        databaseReference.ref.child("Notifications").child(UUID().description).setValue([
            "Title": "Demo",
            "Message" : "There is an error in the program I would like to fix",
            "StartDate" : Date().description,
            "EndDate" : Date().description
        ]);
        print("sent to database");
         */

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
