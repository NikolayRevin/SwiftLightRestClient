//
//  JSONMapper.swift
//  
//
//  Created by Nikolay Revin on 18.05.17.
//  Copyright © 2017 Nikolay Revin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONMapping {
    init?(json: JSON)
}
