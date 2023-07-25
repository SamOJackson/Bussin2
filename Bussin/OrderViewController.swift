//
//  OrdersViewController.swift
//  Bussin
//
//  Created by Sam Jackson on 7/24/23.
//

import UIKit
import Firebase

class OrdersViewController: UIViewController {
    
    let ordersDatabaseManager = OrdersDatabaseManager()

    @IBOutlet weak var OrderNumber: UITextField!
    @IBOutlet weak var detailsText: UITextView!
    
    @IBAction func findOrder(_ sender: Any) {
        guard let orderNumberText = OrderNumber.text, let orderNumber = Int(orderNumberText) else {
            return
        }
        
        let ordersRef = ordersDatabaseManager.databaseReference.child("Orders")
        ordersRef.queryOrdered(byChild: "Order").queryEqual(toValue: orderNumber).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                var orderDetails = ""
                for child in snapshot.children {
                    if let orderSnapshot = child as? DataSnapshot, let orderData = orderSnapshot.value as? [String: Any] {
                        let name = orderData["Name"] as? String ?? ""
                        let cardNumber = orderData["CardNumber"] as? String ?? ""
                        let total = orderData["Total"] as? Double ?? 0.0
                        let dateStr = orderData["Date"] as? String ?? ""
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        if let date = dateFormatter.date(from: dateStr) {
                            let formattedDate = dateFormatter.string(from: date)
                            orderDetails += "Name: \(name)\nCard Number: \(cardNumber)\nTotal: \(total)\nDate: \(formattedDate)\n\n"
                        }
                    }
                }
                self.detailsText.text = orderDetails
            } else {
                self.detailsText.text = "No orders found with the provided order number."
            }
        }
    }
    

}
