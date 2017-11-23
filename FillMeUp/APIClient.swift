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
 static let sharedInstance = APIClient()
    func request(urlString:String,parameters:String? = nil ,onCompletion:@escaping ServiceResponse)
    {
        let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(urlString).responseJSON { (response) in
            if let data = response.result.value {
             
                let json = JSON(data: data as! Data)
                onCompletion(json,nil,true)
        }
        }
    
    }
    
    func get(urlString:String,onCompletion:@escaping ServiceResponse)
    {
        let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
       if  let url = URL(string: encodedStr!)
       {
        let request = NSMutableURLRequest(url:url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let json = JSON(data as? Data)
            if(error == nil)
            {
                onCompletion(json,nil,true )
            }
            else
            {
                onCompletion(json,error as! NSError,false)
            }
        }
        task.resume()
        }
    }
    
}
