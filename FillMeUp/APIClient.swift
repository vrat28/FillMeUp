//
//  APIClient.swift
//  FillMeUp
//
//  Created by Varun Rathi on 19/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

typealias ServiceResponse =  (JSON , NSError?, Bool) -> Void

class APIClient: NSObject
{
    func request(urlString:String,parameters:String? = nil ,onCompletion:@escaping ServiceResponse)
    {
        Alamofire.request("").responseJSON { (response) in
            if let data = response.result.value {
             
                
        }
        }
    
    }
    
}
