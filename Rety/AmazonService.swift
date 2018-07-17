//
//  AmazonService.swift
//  Rety
//
//  Created by Sergej Kunz on 12.07.18.
//  Copyright © 2018 mimacom Deutschland GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AmazonService {
    
    static let APIUrl = "https://amazon-product-api.rety.io/"
    
    static let defaultSession = URLSession(configuration: .default)
    
    static func getProductsByName(name: String, completionHandler: @escaping ([[String:AnyObject]]) -> Void) -> Void {
        
        Alamofire.request(APIUrl, method: .post, parameters: [
            "name": name
        ]).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
            
            if ((response.result.value) != nil) {
                completionHandler(JSON(response.result.value!).arrayObject! as! [[String : AnyObject]])
            }
        }
    }
}
