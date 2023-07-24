//
//  NotificationTableViewController.swift
//  Bussin
//
//  Created by Alexander Gullen on 2023-07-20.
//

import UIKit

import Firebase

class NotificationTableViewController: UITableViewController {
    
    // save a reference to the database
    var databaseReference = Database.database().reference().child("Notifications");
    
    // save a copy of the database in memory
    var databaseNotificationArray: Array<Notification> = Array();
    
    
    //stores the last notification the user selected (primarily used for obtaining the selected notificaton in parent)
    var selectedNotification: Notification?;
    
    // load notifications from the Firebase database into the controller
    func loadNotifications() {
        
        // iterate over every notification in the database
        databaseReference.queryOrderedByKey().observe(.childAdded, with: {
            (notificationSnapshot) in
            
            //load data from the snapshot into a swift Notification Object
            self.databaseNotificationArray.append(Notification.decodeDataSnapshot(dataSnapshot: notificationSnapshot))
            
            //reload the data on the table
            self.tableView.reloadData();
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotifications();
        
        // set the height of the cells to accomodate the text inside them
        self.tableView.rowHeight = 150.0;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.databaseNotificationArray.count
    }

    //handle loading all storyboard cells into the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationTableViewCell
        
        
        cell.lbl_notification_type.text = databaseNotificationArray[indexPath.row].title
        cell.lbl_notification_message.text = databaseNotificationArray[indexPath.row].message
        cell.lbl_notification_startDate.text = databaseNotificationArray[indexPath.row].startDate
        
        //check if there is a value in the notification end date
        if let endDateText = databaseNotificationArray[indexPath.row].endDate {
            
            // if there is set the label to display it
            cell.lbl_notification_endDate.text = databaseNotificationArray[indexPath.row].endDate
        }else{
            // if not tell the label it's undefined
            cell.lbl_notification_endDate.text = "undetermined"
        }

        return cell
    }
    
    
    //handle clicking on individual items in the list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // set the lastSelectedNotification
        selectedNotification = databaseNotificationArray[indexPath.row];
        
        // send a notification to the parent NotificationViewController that indicatates that a value has been selected
        NotificationCenter.default.post(name: NSNotification.Name("com.notification.selected"), object: nil)
        
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
