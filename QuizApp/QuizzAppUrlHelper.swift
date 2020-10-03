//
//  QuizzAppUrlHelper.swift
//  DasQuiz
//
//  Created by Thorsten Claus on 16.02.20.
//  Copyright © 2020 Claus-Software. All rights reserved.
//

import UIKit

class QuizzAppUrlHelper  {
    
    /// Returns a query object with api and optional query parameters
    static func getServiceURLRequest(apiPath : String, queryItems : [URLQueryItem]?) -> URLRequest {
        let username = "quiz"
        let password = "lehn170#Yong"
        let baseURL = "rocky-temple-21345.herokuapp.com"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseURL
        urlComponents.path = apiPath
        urlComponents.queryItems = queryItems
        
        var urlRequest = URLRequest.init(url: urlComponents.url!)
        // Add basic Auth
        let authStr = "\(username):\(password)"
        
        let authData = authStr.data(using: String.Encoding.ascii)
        let authStrData : String = (authData?.base64EncodedString(options: []))!
        urlRequest.setValue("Basic \(authStrData)", forHTTPHeaderField: "Authorization")
        return urlRequest
        
    }
}
