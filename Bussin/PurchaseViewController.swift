//
//  PurchaseViewController.swift
//  Bussin
// Sam Jackson
//  Created by user244653 on 7/20/23.
//

import UIKit

class PurchaseViewController: UIViewController {

    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var Reciept: UITextView!
    @IBOutlet weak var total: UITextView!
    var receivedOrder: String = ""
    var receivedTotal: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        total.text = "Total: $\(receivedTotal)"
    }

    private var orderNumber = Int.random(in: 100000..<999999)
    
    @IBAction func PayNow(_ sender: Any) {
        let username = name.text!;
        let cardNumber = cardNumber.text!;
        Reciept.text = " \(username) , thank you for your purchase. Your order number is: \(orderNumber)\n \(receivedOrder) Total: $\(receivedTotal)";
        
    }

}
