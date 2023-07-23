//
//  NotificationViewController.swift
//  Bussin
//
//  Created by Alexander Gullen on 2023-07-20.
//

import UIKit

import Firebase


class NotificationViewController: UIViewController {
    
    //attach an instance of the list view controller into this controller
    var notificationTableViewController: NotificationTableViewController?;
    
    // attach a view to hold the instance of the list view controller into this controller
    @IBOutlet weak var view_notification_list: UIView!
    
    var databaseReference: DatabaseReference!;
    
    
    // import outlets for selected notifications
    @IBOutlet weak var lbl_selected_notification: UILabel!
    @IBOutlet weak var lbl_selected_notification_title: UILabel!
    @IBOutlet weak var lbl_selected_notification_message: UILabel!
    @IBOutlet weak var lbl_static_selected_notification_end_date: UILabel!
    @IBOutlet weak var lbl_selected_notification_end: UILabel!
    @IBOutlet weak var lbl_static_selected_notification_start_date: UILabel!
    @IBOutlet weak var lbl_selected_notification_start: UILabel!
    
    func hideSelectedNotificationSection(){
        lbl_selected_notification.isHidden = true;
        lbl_selected_notification_title.isHidden = true;
        lbl_selected_notification_message.isHidden = true;
        lbl_static_selected_notification_end_date.isHidden = true;
        lbl_selected_notification_end.isHidden = true;
        lbl_static_selected_notification_start_date.isHidden = true;
        lbl_selected_notification_start.isHidden = true;
    }
    
    func showSelectedNotificationSection(){
        lbl_selected_notification.isHidden = false;
        lbl_selected_notification_title.isHidden = false;
        lbl_selected_notification_message.isHidden = false;
        lbl_static_selected_notification_end_date.isHidden = false;
        lbl_selected_notification_end.isHidden = false;
        lbl_static_selected_notification_start_date.isHidden = false;
        lbl_selected_notification_start.isHidden = false;
    }

    override func viewDidLoad() {
        databaseReference = Database.database().reference();
        super.viewDidLoad()
        
        //set all selected notification labels to invisible while no label is selected
        hideSelectedNotificationSection();

        
        //instanciate notification list controller
        self.notificationTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListController") as? NotificationTableViewController;
        
        //add notificationListViewController
        self.addChild(self.notificationTableViewController!);
            
        //set the view in the frame to the NotificationTableViewController instance
        self.notificationTableViewController!.view.frame = self.view_notification_list.frame;
            
        // pass the view from notificationListViewController to the view_notification_list to allow users to interact with the list from the parent
        self.view.addSubview(self.notificationTableViewController!.view)
            
        notificationTableViewController!.didMove(toParent: self);
        
        // register a notification observer to call notificaitonSelected when a notifiation is selected
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationSelected) , name: NSNotification.Name("com.notification.selected"), object: nil)
        
        
        
    }
    
    @objc func notificationSelected(){
        showSelectedNotificationSection();
        

        
        // if the selected notification is proper
        if let selectedNotification = notificationTableViewController!.selectedNotification {
            
            //set the values in the SelecteLabel section
            lbl_selected_notification_title.text = selectedNotification.title
            lbl_selected_notification_message.text = selectedNotification.message
            lbl_selected_notification_start.text = selectedNotification.startDate;
            
            // if there is a end date to the notification
            if let endDate = selectedNotification.endDate{
                lbl_selected_notification_end.text = endDate;
            }else{
                // hide the notification again
                lbl_static_selected_notification_end_date.isHidden = true;
                lbl_selected_notification_end.isHidden = true;
            }
            

            
            
        }else{
            print("no selected notification")
        }
        
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
