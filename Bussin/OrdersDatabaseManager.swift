//
//   DatabaseManager.swift
//  Bussin
//
//  Created by Sam Jackson on 7/20/23.
//

import Foundation

import Firebase

class OrdersDatabaseManager {
    private var databaseReference: DatabaseReference!

    init() {
        FirebaseApp.configure()
        databaseReference = Database.database().reference()
    }

    func addOrder(name: String, cardNumber: String, total: Double, date: Date) {
        let orderId = UUID().uuidString
        
        let orderData: [String: Any] = [
            "Name": name,
            "CardNumber": cardNumber,
            "Total": total,
            "Date": date.description
        ]
        databaseReference.child("Orders").child(orderId).setValue(orderData) { (error, _) in
            if let error = error {
                print("Error adding order: \(error)")
            } else {
                print("Order added successfully to the database.")
            }
        }
    }
}
