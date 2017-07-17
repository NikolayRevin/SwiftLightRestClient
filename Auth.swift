//
//  Auth.swift
//  
//
//  Created by Nikolay Revin on 14.05.17.
//  Copyright © 2017 Nikolay Revin. All rights reserved.
//

import Foundation
import Alamofire

class Auth {
    public let login: String
    public let password: String
    
    public var base64: (key: String, value: String)? {
        guard let authorizationHeader = Request.authorizationHeader(user: login, password: password) else { return nil }
        return (key: authorizationHeader.key, value: authorizationHeader.value)
    }
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}
