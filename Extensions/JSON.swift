//
//  JSON.swift
//  
//
//  Created by Nikolay Revin on 18.05.17.
//  Copyright © 2017 Nikolay Revin. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    public func mapping<T>(type: T?) -> Any? {
        if let base = type as? JSONMapping.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    arrObject.append(base.init(json: obj)!)
                }
                return arrObject
            } else {
                return base.init(json: self)
            }
        }
        return nil
    }
}
