//
//  StripeTools.swift
//  Rich
//
//  Created by Паша on 08.10.16.
//  Copyright © 2016 Паша. All rights reserved.
//

import Foundation
import Stripe

struct StripeTools {
    
    //store stripe secret key
    private var stripeSecret = "sk_test_TVAf6cKGQGvu1hif18mMQPtM"
    
    //generate token each time you need to get an api call
    func generateToken(card: STPCardParams, completion: @escaping (_ token: STPToken?) -> Void) {
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                completion(token)
            }
            else {
                print(error)
                completion(nil)
            }
        }
        
    }
    
    func getBasicAuth() -> String{
        return "Bearer \(self.stripeSecret)"
    }
    
    
    
}
