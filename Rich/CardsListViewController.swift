
//  CardsListViewController.swift
//  Rich
//
//  Created by Паша on 08.10.16.
//  Copyright © 2016 Паша. All rights reserved.
//

import UIKit
import Stripe

class CardsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, STPPaymentCardTextFieldDelegate, STPAddCardViewControllerDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var cardsTableView: UITableView!
//    @IBOutlet weak var cardTextField: STPPaymentCardTextField! = nil
    @IBOutlet weak var AddCardButton: UIButton!
    @IBOutlet weak var AddCardImage: UIImageView!
    @IBOutlet weak var AddCardView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let activitiIndicator = STPPaymentActivityIndicatorView.init()
    
    var cardTextField: STPPaymentCardTextField! = nil
//    var submitButton: UIButton! = nil
    
    var stripeUtil = StripeUtil()
    var cards = [AnyObject]()
    var tokens = [String : String]()
    
    let imageSize = CGSize.init(width: 20, height: 20)
    let imageX : CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        if let data = userDefaults.value(forKey: "tokens") as! NSData? {
            self.tokens = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [String: String]
        }
        // Do any additional setup after loading the view.
        
//        cardTextField = STPPaymentCardTextField(frame: CGRect.init(x: 15, y: 100, width: view.frame.width - 30, height: 44))
////        cardTextField.delegate! = self
//        view.addSubview(cardTextField)
//        submitButton = UIButton(type: UIButtonType.system)
//        submitButton.frame = CGRect .init(x: 15, y: 100, width: 100, height: 44)
//        submitButton.isEnabled = false
//        submitButton.setTitle("Submit", for: UIControlState.normal)
//        submitButton.addTarget(self, action: #selector(self.submitCard(_ :)), for: UIControlEvents.touchUpInside)
//        view.addSubview(submitButton)
        
//        let cellHeight = UITableViewCell.init().frame.height
        
        AddCardImage.frame.origin.x = imageX + 5
//        AddCardImage.frame.size = imageSize
        AddCardButton.frame.origin.x = AddCardImage.frame.maxX + imageX + 5
        AddCardImage.image = UIImage.init(named: "Stripe.bundle/stp_icon_add.png")
        
//        AddCardView.addTarget(self, action: #selector(self.addCard(_ :)), for: UIControlEvents.touchUpInside)
//        let tap = UIGestureRecognizer.init(target: self, action: #selector(self.addCard(_ :)))
//        AddCardView.addGestureRecognizer(tap)
        headerView.image = UIImage.init(named: "Stripe.bundle/stp_card_form_front.png")
        AddCardView.frame.size = CGSize.init(width: self.scrollView.frame.width, height: self.AddCardView.frame.height)
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelView(_ :))), animated: false)
        
        
        self.cardsTableView.delegate = self
        self.cardsTableView.dataSource = self
        self.cardsTableView!.register(UINib(nibName: "CardCell", bundle: Bundle(for: self.classForCoder)), forCellReuseIdentifier: "cardCell")
//        self.cardsTableView.reloadData()
        self.cardsTableView.frame.size = CGSize.init(width: self.scrollView.frame.width, height: UITableViewCell.init().frame.height * 5 )
        self.cardsTableView.tableFooterView = UIView.init()
//        self.cardsTableView.frame.origin.y = self.headerView.frame.maxY
        
//        self.activitiIndicator = STPPaymentActivityIndicatorView.init()
        self.activitiIndicator.center = self.view.center//self.cardsTableView.center
        self.activitiIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activitiIndicator)
//        self.activitiIndicator.tintColor = UIColor.blue
        
        self.AddCardView.frame.origin.y = self.cardsTableView.frame.maxY + 20
        
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize.init(width: self.view.frame.width, height: self.view.frame.height)
        
        getCardsList()
    }
    
    func cancelView(_ sender: AnyObject ) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
//        submitButton.isEnabled = textField.valid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
   
    
    @IBAction func AddCard(_ sender: AnyObject) {
        
        addCardViewPresent()
        
    }
    
    func addCardViewPresent() {
        
        let addCardViewController = STPAddCardViewController.init()
        //        addCardViewController.
        addCardViewController.delegate = self
        
        // STPAddCardViewController must be shown inside a UINavigationController.
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        //        userDefaults.setValue(self.customerId, forKey: "customerId")
        //        userDefaults.synchronize()
        
//        postStripeToken4(token)
//        addCardViewController.prefilledInformation.
        
        postStripeToken(token)
        
//        if let tokenId = stripeUtil.customerId {
//            //if yes, call the createCard method of our stripeUtil object, pass customer id
//            self.stripeUtil.createCard(stripeId: tokenId, token: token, completion: { (success) in
//                //there is a new card !
//                self.tokens.updateValue(token.stripeID , forKey: (token.card?.cardId)!)
//                let data = NSKeyedArchiver.archivedData(withRootObject: self.tokens)
//                userDefaults.setValue(data, forKey: "tokens")
//                userDefaults.synchronize()
//                self.getCardsList()
//            })
//        }
//        else {
//            //if not, create the user with our createUser method
//            self.stripeUtil.createUser(token: token, completion: { (success) in
//                self.tokens.updateValue(token.stripeID, forKey: (token.card?.cardId)!)
//                let data = NSKeyedArchiver.archivedData(withRootObject: self.tokens)
//                userDefaults.setValue(data, forKey: "tokens")
//                userDefaults.synchronize()
//                self.getCardsList()
//            })
//        }
        self.dismiss(animated: true, completion: {
            //                    self.showReceiptPage()
            //                    completion(nil)
        })
    
        
    }
   
    
    
//    func sendCard(cardParams: STPCardParams) {
//        //extract the card parameters given by the STPCardTextField
//        let params = cardTextField.cardParams
//        
//            // do something here when a highscore exists
////        let a = userDefaults.value(forKey: "customerId") as! String?
//        
//        
//        //check if the customerId exist
//        if let tokenId = stripeUtil.customerId {
//            //if yes, call the createCard method of our stripeUtil object, pass customer id
//            self.stripeUtil.createCard(stripeId: tokenId, token: params, completion: { (success) in
//                //there is a new card !
//                self.getCardsList()
//            })
//        }
//        else {
//            //if not, create the user with our createUser method
//            self.stripeUtil.createUser(token: params, completion: { (success) in
//                self.getCardsList()
//            })
//        }
//    }
    
    
    func getCardsList() {
        
        self.activitiIndicator.isHidden = false
        self.activitiIndicator.setAnimating(true, animated: true)
        
        stripeUtil.customerId = userDefaults.value(forKey: "customerId") as! String?
        
        
        if stripeUtil.customerId != nil {
            self.stripeUtil.getCardsList(completion: { (result) in
                if let result = result {
                    self.cards = result
                    
                }
                //store results on our cards, clear textfield and reload tableView
                DispatchQueue.main.async(execute: {
//                    self.cardTextField.clear()
                    self.cardsTableView.reloadData()
                    
                    self.activitiIndicator.setAnimating(false, animated: true)
                    
                })
            })
        } else {
            
            addCardViewPresent()
            
            self.activitiIndicator.setAnimating(false, animated: true)
        }
        
        
    }

    
    // MARK: TableViewDelegate
    
//   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        //only one section
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //count on our cards array
        return self.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get card cell with cardCell identifier don't forget it on your storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! CardCell
//        var a = UIImage()
    
        //get the last4 value on the card json, create the string and pass it to the label
        if let last4 = self.cards[indexPath.row]["last4"] , let brand = self.cards[indexPath.row]["brand"] {
            //cell.cardNumberLabel.text = "\(brand!) Ending in \(last4!)"
            let text : NSMutableAttributedString = NSMutableAttributedString.init(string: "\(brand!) Ending in \(last4!)")
            text.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange.init(location: (brand! as! String).characters.count + 1, length: 9) )
            
            cell.cardNumberLabel.attributedText = text
            
            
            
            cell.cardImage.image = UIImage.init(named: "Stripe.bundle/stp_card_\(String(describing: brand!).lowercased())_template.png")
            //            a =  cell.cardImage.image!
            
            
            cell.cardImage.frame.origin.x = imageX
            cell.cardNumberLabel.frame.origin.x = cell.cardImage.frame.maxX + imageX
            
            
        }
        
        
        
        //get the month/year expiration values on the card json, create the string and pass it to the label
        if let expirationMonth = self.cards[indexPath.row]["exp_month"], let expirationYear = self.cards[indexPath.row]["exp_year"] {
            cell.expirationLabel.text = "\(expirationMonth!)/\(expirationYear!)"
        }
        
        return cell
    }
    
    var selectedCard : [String : AnyObject]?
    var selectedCardTokenId : String?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        selectedCard = cards[indexPath.row] as? [String : AnyObject]
        selectedCardTokenId = tokens[selectedCard?["id"] as! String]
        
        self.performSegue(withIdentifier: "unwindToMainView", sender: self)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //         Get the new view controller using segue.destinationViewController.
        //         Pass the selected object to the new view controller.
        
    }
    
    
    
    func postStripeToken(_ token: STPToken)
    {

        let amountTextField = UITextField.init()
        amountTextField.text = "5"

        let emailTextField = UITextField.init()
        emailTextField.text = "Shuzaa@me.com"

        var request = URLRequest(url: URL(string: "http://localhost/donate/payment.php")!)
        request.httpMethod = "POST"
        let postString = "stripeToken=\(token.stripeID)&amount=\(Int(amountTextField.text!)!)&currency=\("usd")&description=\(emailTextField.text!)"

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
                let a = UIAlertController.init(title: "good", message: responseString as String?, preferredStyle: UIAlertControllerStyle.alert)

                self.dismiss(animated: true, completion: {
                    //                    self.showReceiptPage()
                    //                    completion(nil)
                })



            }
            
            print("responseString = \(responseString)")
        })
        
        
        task.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
