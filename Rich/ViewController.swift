//
//  ViewController.swift
//  Rich
//
//  Created by Паша on 06.10.16.
//  Copyright © 2016 Паша. All rights reserved.
//

import UIKit
import Stripe
//import NS
//import AF


let userDefaults = UserDefaults.standard

let mainYellowColor = UIColor.init(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate, UIScrollViewDelegate {
    
//
//    let backendBaseURL: String? = "https://richest.herokuapp.com"
    
//    
//    var paymentContext: STPPaymentContext?
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var MainButton: UIButton!
    
    @IBOutlet weak var PayButton: UIButton!
    @IBOutlet weak var AdvertButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var CircleForMoney: UIImageView!
//    let paymentRow: Chec

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view, typically from a nib.
        
        self.scrollView.delegate = self

        StylishButton(PayButton)
        StylishButton(AdvertButton)
        
        self.scrollView.contentSize = CGSize.init(width: self.view.frame.width, height: self.scrollView.frame.height)
//        CircleForMoney.frame.origin = CGPoint.init(x: MainButton.frame.minX, y: MainButton.frame.minY)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        addCircleView()
        self.view.bringSubview(toFront: self.MainButton)
    }
    
    func addCircleView() {
        
        let indent : CGFloat = 65
        
        let circleWidth = MainButton.frame.width + indent
        let circleHeight = circleWidth
        
        let diceRollX = MainButton.frame.origin.x - indent/2
        let diceRollY = MainButton.frame.origin.y - indent/2
        
        // Create a new CircleView
        let circleView = CircleView(frame: CGRect.init(x: diceRollX, y: diceRollY, width: circleWidth, height: circleHeight))
        
        HeaderView.addSubview(circleView)
//        view.sendSubview(toBack: circleView)
//        view.sendSubview(toBack: HeaderView)
        HeaderView.bringSubview(toFront: MainButton)
//        circleView.addSubview(MainButton)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(duration: 1.0)
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            // your function here
            self.addCircleView()
            
        })
    }
    
    
    func StylishButton (_ button: UIButton) {
        
        
        button.layer.borderWidth = 2
        button.layer.borderColor = mainYellowColor.cgColor
        button.frame.size = CGSize.init(width: self.view.frame.width*0.44, height: 40)
        button.center.x = self.view.frame.width/2
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.white
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    @IBAction func submitCard(_ sender: AnyObject?) {
//        // If you have your own form for getting credit card information, you can construct
//        // your own STPCardParams from number, month, year, and CVV.
//        let card = paymentTextField.cardParams
//        
//        STPAPIClient.shared().createToken(withCard: card) { token, error in
//            guard token != nil else {
//                NSLog("Error creating token: %@", error!.localizedDescription);
//                return
//            }
//            
//            // TODO: send the token to your server so it can create a charge
////            let alert = UIAlertController(title: "Welcome to Stripe", message: "Token created: \(stripeToken)", preferredStyle: .alert)
////            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////            self.present(alert, animated: true, completion: nil)
//            
//            self.postStripeToken4(token!)
//        }
//        
////        STPAPIClient.
//    }
    
    
    
//    @IBAction func buyButton(_ sender: AnyObject) {
//        
////        addCard()
//        
////        let s = STPUserInformation.init()
////        s.
//        
//        let config = STPPaymentConfiguration.shared()
//        
//        paymentContext = STPPaymentContext.init(apiAdapter: MyAPIClient.sharedClient ,
//                                                configuration: config,
//                                                theme: .default())
//        //        paymentContext.delegate = self
//        paymentContext?.hostViewController = self
////        paymentContext?.prefilledInformation.phone = "89854890333"
//        
////        let paymentMetodsViewController = STPPaymentMethodsViewController.init(paymentContext: paymentContext!)
////        
////        
////        let navigationController = UINavigationController(rootViewController: paymentMetodsViewController)
////        self.present(navigationController, animated: true, completion: nil)
//        
//        
//        self.paymentContext?.presentPaymentMethodsViewController()
//        
//        
//        
//        
//        
////        paymentContext.presentPaymentMethodsViewController()//pushPaymentMethodsViewController()
////        self.paymentRow.onTap = { [weak self] _ in
////            self.paymentContext?. //presentPaymentMethodsViewController()
////        }
////
////        applePayTapped()
//        
////        let a = STPPaymentContext.init()
////        a.presentPaymentMethodsViewController()
//        
//    }
    
    
    
    
    
    
    func applePayTapped() {
//        let paymentRequest = ... // see above
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: "com.merchant.your_application")
        // Configure the line items on the payment sheet
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Fancy hat", amount: NSDecimalNumber(string: "50.00")),
            // the final line should represent your company; it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
            PKPaymentSummaryItem(label: "iHats, Inc", amount: NSDecimalNumber(string: "50.00")),
        ]
        
//        if let paymentRequest = paymentRequest , Stripe.canSubmitPaymentRequest(paymentRequest) {
            let paymentAuthorizationVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentAuthorizationVC.delegate = self
            self.present(paymentAuthorizationVC, animated: true, completion: nil)
//        } else {
            // there is a problem with your Apple Pay configuration.
//        }
    }
    
    // MARK: PKPaymentAuthorizationViewControllerDelegate
    
    var paymentSucceeded: Bool = false
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token, error) in
//            self.submitTokenToBackend(token, completion: { (error: NSError?) in
//                if let error = error {
//                    completion(.Failure)
//                } else {
                    self.paymentSucceeded = true
//                    completion(.Success)
//                }
//            })
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: true, completion: {
            if (self.paymentSucceeded) {
                // show a receipt page
            }
        })
    }
   
    
   
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func postStripeToken(_ token: STPToken) {
//        
//        amountTextField = UITextField.init()
//        amountTextField?.text = "12"
//        
//        emailTextField = UITextField.init()
//        emailTextField?.text = "Shuzaa@me.com"
//        
//        let URL = "http://localhost/donate/payment.php"
//        let params = ["stripeToken": token.stripeID,
//                      "amount": Int(self.amountTextField!.text!)!,
//                      "currency": "usd",
//                      "description": self.emailTextField!.text!] as [String : Any]
//        
//        
////        let manager = AFHTTPSessionManager()
////        manager.requestSerializer = AFJSONRequestSerializer()
////        manager.responseSerializer = AFHTTPResponseSerializer()
//        
//        let manager = AFHTTPRequestOperationManager()
//        
////        manager.responseSerializer = AFHTTPResponseSerializer()
//        let serializer = AFHTTPRequestSerializer.init()
//        serializer.stringEncoding = String.Encoding.utf8.rawValue
//        manager.requestSerializer = serializer
//
//        let serializer2 = AFHTTPResponseSerializer.init()
//        serializer2?.stringEncoding = String.Encoding.utf8.rawValue
////        manager.responseSerializer = AFHTTPResponseSerializer
//        
//        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
//       
//        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        manager.responseSerializer = AFJSONResponseSerializer.init(readingOptions: JSONSerialization.ReadingOptions.allowFragments )
//         manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html", "application/json", "text/json", "text/javascript", "text/html", "text/plain"]) as Set<NSObject>
//        
//        
//        
//        
//        manager.post(URL, parameters: params, success: { (operation, responseObject) -> Void in
//            
////            if
//                let response = responseObject as? [String: Any] 
//                UIAlertView(title: response?["status"] as! String?,
//                            message: response?["message"] as! String?,
//                            delegate: nil,
//                            cancelButtonTitle: "OK").show()
//            
//            let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
//            print(result)
////            }
//            
////            print(responseObject)
////            print(responseObject[0 as Any])
//            print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
//            
//        }) { (operation, error) -> Void in
//            UIAlertView(title: "Please Try Again",
//                        message: error?.localizedDescription,
//                        delegate: nil,
//                        cancelButtonTitle: "OK").show()
//            
//            print("BBBBBBBBBBBBBBBBBBBBBBBBBBBB")
//        }
//    }
    



}

