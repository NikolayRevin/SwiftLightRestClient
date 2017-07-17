//
//  ApiProtocol.swift
//  
//
//  Created by Nikolay Revin on 09.05.17.
//  Copyright © 2017 Nikolay Revin. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiClientProtocol {
    init(host: String)
    init(host: String, path: String)
    init(host: String, defaultHeaders headers: HTTPHeaders)
    init(host: String, path: String, defaultHeaders headers: HTTPHeaders)
    func request(fromPath path: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, withHeaders headers: HTTPHeaders?, completionHandler: ((DataResponse<Any>) -> Void)?, errorHandler: ((DataResponse<Any>?) -> Void)?)
    func post(fromPath path: String, parameters: Parameters?, encoding: ParameterEncoding, withHeaders headers: HTTPHeaders?, completionHandler: ((DataResponse<Any>) -> Void)?, errorHandler: ((DataResponse<Any>?) -> Void)?)
    func get(fromPath path: String, parameters: Parameters?, withHeaders headers: HTTPHeaders?, completionHandler: ((DataResponse<Any>) -> Void)?, errorHandler: ((DataResponse<Any>?) -> Void)?)
    func url(byPath path: String) -> String
}

protocol ApiClientDelegate {
    func restAPINotInternetConnection(_ object: ApiClientProtocol)
    func restAPINotServerConnection(_ object: ApiClientProtocol, serverResponse response: DataResponse<Any>)
}
