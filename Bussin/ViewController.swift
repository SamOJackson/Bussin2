//
//  ViewController.swift
//  Bussin
//  Created by Sam Jackson on 7/12/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var firstTotal: UILabel!

    // Passes
    public var order: String = "Order Details: "
    public var total: Double = 0
    @IBOutlet weak var totalTextBox: UITextView!
    public var doubleTotal: String = "0"

    @IBAction func AddDayPass(_ sender: Any) {
        total += 10
        order.append(" Daily Pass,")
        totalTextBox.text = order
        let doubleTotal = String(format: "%.2f", total)
        firstTotal.text = "Total: \(String(doubleTotal))"
    }

    @IBAction func AddWeeklyPass(_ sender: Any) {
        total += 25
        order.append(" Weekly Pass,")
        totalTextBox.text = order
        let doubleTotal = String(format: "%.2f", total)
        firstTotal.text = "Total: \(String(doubleTotal))"
    }

    @IBAction func AddMonthlyPass(_ sender: Any) {
        total += 50
        order.append(" Monthly Pass,")
        totalTextBox.text = order
        doubleTotal = String(format: "%.2f", total)
        firstTotal.text = "Total: \(String(doubleTotal))"
    }

//    comment

    @IBAction func CheckOut(_ sender: Any) {
        performSegue(withIdentifier: "showPurchaseViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPurchaseViewController" {
            if let destinationVC = segue.destination as? PurchaseViewController {
                destinationVC.receivedOrder = order
                destinationVC.receivedTotal = String(total)
                
            }
        }
    }
}

