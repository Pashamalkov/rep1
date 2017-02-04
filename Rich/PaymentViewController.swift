//
//  PaymentViewController.swift
//  Rich
//
//  Created by Паша on 16.10.16.
//  Copyright © 2016 Паша. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class PaymentViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var PaymentButton: UIButton!
    @IBOutlet weak var PaymentView: UIView!
    @IBOutlet weak var PaymentText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedCard : [String : AnyObject]?
    var selectedCardTokenId : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        // Do any additional setup after loading the view.
        
        headerView.image = UIImage.init(named: "Stripe.bundle/stp_card_form_front.png")
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelView(_ :))), animated: false)
        
        
//        
//        self.activitiIndicator.center = self.view.center//self.cardsTableView.center
//        self.activitiIndicator.hidesWhenStopped = true
//        self.view.addSubview(self.activitiIndicator)
        //        self.activitiIndicator.tintColor = UIColor.blue
        
        
        
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize.init(width: self.view.frame.width, height: self.view.frame.height)
        
    }
    
    func cancelView(_ sender: AnyObject ) {
        //        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToPaymentView(_ sender: UIStoryboardSegue) {
        
        if let sourceViewController : CardsListViewController = sender.source as? CardsListViewController {
            // Add a new meal.
            selectedCard = sourceViewController.selectedCard
            selectedCardTokenId = sourceViewController.selectedCardTokenId
            
            PaymentText.text = selectedCard?["last4"] as! String?
            
            
            
        }
        
       
        
    }
    
    @IBAction func PayButtonAction(_ sender: AnyObject) {
        
        
        postStripeToken(selectedCardTokenId!)
        
    }
   
    
    func postStripeToken(_ tokenId: String)
    {
        
        let amountTextField = UITextField.init()
        amountTextField.text = "5"
        
        let emailTextField = UITextField.init()
        emailTextField.text = "Shuzaa@me.com"
        
        var request = URLRequest(url: URL(string: "http://localhost/donate/payment.php")!)
//        var request = URLRequest(url: URL(string: "https://api.stripe.com/v1")!)
        
        request.httpMethod = "POST"
        let postString = "stripeToken=\(tokenId)&amount=\(Int(amountTextField.text!)!)&currency=\("usd")&description=\(emailTextField.text!)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            } else {
                
                //                if let response = responseObject as? [String: String] {
                _ = UIAlertController.init(title: "good", message: responseString as String?, preferredStyle: UIAlertControllerStyle.alert)
                
                self.dismiss(animated: true, completion: {
                    //                    self.showReceiptPage()
                    //                    completion(nil)
                })
                
                
                
            }
            
            print("responseString = \(responseString)")
        })
        
        
        task.resume()
    }
    
    
    //create card for given user
//    func postStripeToken2(stripeId: String, token: STPToken?, completion: @escaping (_ success: Bool) -> Void) {
//        
//        //        stripeTool.generateToken(card: card) { (token) in
//        if(token != nil) {
//            let request = NSMutableURLRequest(url: NSURL(string: "https://api.stripe.com/v1/customers/\(stripeId)/sources")! as URL)
//            
//            //token needed
//            var params = [String:String]()
//            params["source"] = token!.tokenId
//            
//            var str = ""
//            params.forEach({ (key, value) in
//                str = "\(str)\(key)=\(value)&"
//            })
//            
//            //basic auth
//            request.setValue(self.stripeTool.getBasicAuth(), forHTTPHeaderField: "Authorization")
//            
//            request.httpMethod = "POST"
//            
//            request.httpBody = str.data(using: String.Encoding.utf8)
//            
//            self.dataTask = self.defaultSession.dataTask(with: request as URLRequest) { (data, response, error) in
//                
//                if let error = error {
//                    print(error)
//                    completion(false)
//                }
//                else if let data = data {
//                    _ = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    //                        print(json)
//                    completion(true)
//                }
//            }
//            
//            self.dataTask?.resume()
//        }
//        //        }
//        
//    }
    
    
    
    
    
//    func postStripeToken(_ tokenId: STPToken)
//    {
//
//        let amountTextField = UITextField.init()
//        amountTextField.text = "5"
//        
//        let emailTextField = UITextField.init()
//        emailTextField.text = "Shuzaa@me.com"
//        
//        var request = URLRequest(url: URL(string: "http://localhost/donate/payment.php")!)
//        request.httpMethod = "POST"
//        let postString = "stripeToken=\(token.stripeID)&amount=\(Int(amountTextField.text!)!)&currency=\("usd")&description=\(emailTextField.text!)"
//        
//        request.httpBody = postString.data(using: String.Encoding.utf8)
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
//            guard error == nil && data != nil else {                                                          // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//            
//            
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            
//            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            } else {
//                
//                //                if let response = responseObject as? [String: String] {
//                let a = UIAlertController.init(title: "good", message: responseString as String?, preferredStyle: UIAlertControllerStyle.alert)
//                
//                self.dismiss(animated: true, completion: {
//                    //                    self.showReceiptPage()
//                    //                    completion(nil)
//                })
//                
//                
//                
//            }
//            
//            print("responseString = \(responseString)")
//        })
//        
//        
//        task.resume()
//    }
    
//    func convertToSTPCardParams(_ card : [String : AnyObject]) {
//        
//        let params = STPCardParams.init()
//        params.address = card["address"] as! STPAddress
//        params.cvc = card["cvc"] as! String?
//        params.expYear = card["expYear"]
//        params.expMonth = card["expMonth"]
//        params.last4() = card["last4"]
//        params.name = card["name"]
//        params.number = card["number"]
//        
//        
//        
//    }

    
}
