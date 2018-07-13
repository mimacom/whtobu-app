//
//  AmazonService.swift
//  Rety
//
//  Created by Sergej Kunz on 12.07.18.
//  Copyright © 2018 mimacom Deutschland GmbH. All rights reserved.
//

import Foundation

class AmazonService {
    public static let AccessKey = "AKIAJ3ZRP5G3JDE3QDPA"
    public static let AccessSecretKey = "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"
    public static let AssociateTag = "mimacomrety-21"
    public static let ProductAdvertisingApiUrl = "https://webservices.amazon.com/onca/xml"
  
    static let defaultSession = URLSession(configuration: .default)
    static var dataTask: URLSessionDataTask?
    
    static func getProductsByName(name: String) -> [Product] {
        
        dataTask?.cancel()
        
        let result: [Product] = []
        
        let awsSignature = AWSSignature()
        let signature = awsSignature.itemLookUp("B075M2DTZV")
        
        let url = AmazonService.createURLWithComponents(signature: signature)
       
        dataTask = defaultSession.dataTask(with: url!) { data, response, error in
            defer { self.dataTask = nil }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
            
                print("Data", data)
            }
            
            print("Response", response)
        }
        
        dataTask?.resume()
        
        // print("Items", items)
        
        return result
    }
    
    static func createURLWithComponents(signature: [String:AnyObject]) -> URL? {
        var urlComponents = URLComponents(string: AmazonService.ProductAdvertisingApiUrl)
        
        urlComponents?.queryItems = []
        
        for (name, value) in signature {
            let encodedValue = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            urlComponents?.queryItems?.append(URLQueryItem(name: name, value: encodedValue))
        }

        return try! urlComponents?.asURL()
    }
}
