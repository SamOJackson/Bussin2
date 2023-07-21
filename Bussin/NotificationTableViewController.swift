//
//  NotificationTableViewController.swift
//  Bussin
//
//  Created by Alexander Gullen on 2023-07-20.
//

import UIKit

import Firebase

class NotificationTableViewController: UITableViewController {
    
    
    var databaseReference: DatabaseReference!;
    
    var databaseNotificationArray: Array<Notification> = Array();
    
    
    // load notifications from the Firebase database into the controller
    func loadNotifications() {
        Task{
            do{
                let inMemoryDatabase = try await databaseReference.ref.child("Notifications").getData();
                for child in inMemoryDatabase.children{
                    print("child",child);
                    print("typeof",type(of: child))
                }
            }catch{
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        databaseReference = Database.database().reference();
        
        var databaseObserver = databaseReference.child("Notifications").observe( .value, with: { snapshot in
            for child in snapshot.children{
                //let currentNotification = new Notifcation(id: child);
                
                
                print("data in child",child);
                
                print("type of child ",type(of: child))
                
            }
        })
        
        
        //var inMemoryDatabase = loadNotifications();
        
        print("data in databaseNotificationArray",databaseNotificationArray);
        
        //code to access database
        /*
        databaseReference.ref.child("Notifications").setValue([
            "Title": "Demo",
            "Message" : "There is an error in the program I would like to fix",
            "StartDate" : Date(),
            "EndDate" : Date()
        ]);
         */
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        
        /*
        cell.lbl_notification_type.text
        cell.lbl_notification_message.text
        cell.lbl_notification_image.text
        cell.lbl_notification_startDate.text
        cell.lbl_notification_endDate.text
         */

        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
