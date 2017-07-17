//
//  ResponseModel.swift
//  
//
//  Created by Nikolay Revin on 16.05.17.
//  Copyright © 2017 Nikolay Revin. All rights reserved.
//

import Foundation

public class RESTApiClientError {
    let code: Int
    let text: String?
    
    init(code: Int, text: String?) {
        self.code = code
        self.text = text
    }
}
