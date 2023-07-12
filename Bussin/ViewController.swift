//
//  ViewController.swift
//  Bussin
//
//  Created by user244653 on 7/12/23.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var finalTotal: UITextView!
    
    //Passes
    public var order: String = "Order Details: ";
    public var total: Double = 0;
    @IBOutlet weak var totalTextBox: UITextView!
    public var doubleTotal: String = "0";
    //Payment
    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var name: UITextField!
   
    @IBOutlet weak var Reciept: UITextView!
    
    @IBOutlet weak var firstTotal: UILabel!
    @IBAction func AddDayPass(_ sender: Any) {
        total += 10;
        order.append(" Daily Pass,");
        totalTextBox.text = order;
        let doubleTotal = String(format: "%.2f", total);
        firstTotal.text = "Total:  \(String(doubleTotal))";
    }
    @IBAction func AddWeeklyPass(_ sender: Any) {
        total += 25;
        order.append(" Weekly Pass,");
        totalTextBox.text = order;
        let doubleTotal = String(format: "%.2f", total);
        firstTotal.text = "Total:  \(String(doubleTotal))";
        
    }
    @IBAction func AddMonthlyPass(_ sender: Any) {
        total += 50;
        order.append(" Monthly Pass,");
        totalTextBox.text = order;
        doubleTotal = String(format: "%.2f", total);
        firstTotal.text = "Total:  \(String(doubleTotal))";
    }
    
    
    @IBAction func CheckOut(_ sender: Any) {
        let finalT = doubleTotal;
        finalTotal.text = "Total: \(String(finalT))";
    }
    
    
  
    
    
   
 //passes 2
    private var orderNumber = Int.random(in: 100000..<999999)
    
    @IBAction func PayNow(_ sender: Any) {
        let username = name.text!;
        let cardNumber = cardNumber.text!;
        Reciept.text = " \(username) , Thank you for your purchase. Your order number is : \(orderNumber)  Order of: \(order)";
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

