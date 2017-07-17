//
//  Api.swift
//  
//
//  Created by Nikolay Revin on 09.05.17.
//  Copyright © 2017 Nikolay Revin. All rights reserved.
//

import Foundation
import Alamofire

class RESTApiClient: ApiClientProtocol {
    
    private let apiURL: String
    
    private let networkManager: NetworkReachabilityManager
    
    private var defaultHeaders: HTTPHeaders = [:]
    
    public var delegate: ApiClientDelegate? = nil
    
    public var auth: Auth! = nil
    
    required init(host: String) {
        apiURL = host
        networkManager = NetworkReachabilityManager(host: host)!
    }
    
    required convenience init(host: String, path: String) {
        self.init(host: host + path)
    }
    
    required convenience init(host: String, defaultHeaders headers: HTTPHeaders) {
        self.init(host: host, path: "", defaultHeaders: headers)
    }
    
    required convenience init(host: String, path: String, defaultHeaders headers: HTTPHeaders) {
        self.init(host: host, path: path)
        defaultHeaders = headers
    }
    
    public func isConnectedToInternet() -> Bool {
        return networkManager.isReachable
    }
    
    public func getHeaders(headers: HTTPHeaders?) -> HTTPHeaders {
        var headers = defaultHeaders
        
        if let auth = self.auth, let authHeader = auth.base64  {
            headers[authHeader.key] = authHeader.value
        }
        
        return headers
    }
    
    internal func request(
        fromPath path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        withHeaders headers: HTTPHeaders? = nil,
        completionHandler: ((DataResponse<Any>) -> Void)? = nil,
        errorHandler: ((DataResponse<Any>?) -> Void)? = nil
    ) {
        guard isConnectedToInternet() else {
            notifyNotInternetConnection()
            if let error = errorHandler {
                error(nil)
            }
            return
        }
        
        let headers = getHeaders(headers: headers)
        let requestURL = url(byPath: path)
        #if DEBUG
        print("url \(requestURL)")
        #endif
        Alamofire
            .request(requestURL, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .responseJSON { [weak self] responseResult in
                guard let object = self else {
                    #if DEBUG
                    print("API object error")
                    #endif
                    return
                }
                
                if responseResult.result.isFailure || responseResult.response == nil {
                    object.notifyServerConnection(serverResponse: responseResult)
                    
                    if let error = errorHandler {
                        error(responseResult)
                    }
                    
                    return
                }
                
                if let completion = completionHandler {
                    completion(responseResult)
                }
        }
    }
    
    public func post(
        fromPath path: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding,
        withHeaders headers: HTTPHeaders?,
        completionHandler: ((DataResponse<Any>) -> Void)?,
        errorHandler: ((DataResponse<Any>?) -> Void)?
    ) {
        request(fromPath: path, method: .post, encoding: encoding, withHeaders: headers, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    public func post(fromPath path: String, URLParameters parameters: Parameters? = nil, completionHandler: ((DataResponse<Any>) -> Void)?, errorHandler: ((DataResponse<Any>?) -> Void)?) {
        post(fromPath: path, parameters: parameters, encoding: URLEncoding.default, withHeaders: nil, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    public func post(fromPath path: String, JSONParameters parameters: Parameters? = nil, completionHandler: ((DataResponse<Any>) -> Void)?, errorHandler: ((DataResponse<Any>?) -> Void)?) {
        post(fromPath: path, parameters: parameters, encoding: JSONEncoding.default, withHeaders: nil, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    public func get(fromPath path: String, parameters: Parameters? = nil, withHeaders headers: HTTPHeaders? = nil, completionHandler: ((DataResponse<Any>) -> Void)? = nil, errorHandler: ((DataResponse<Any>?) -> Void)? = nil) {
        request(fromPath: path, method: .get, parameters: parameters, encoding: URLEncoding.default, withHeaders: headers, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    internal func url(byPath path: String) -> String {
        return apiURL + path
    }
    
    private func notifyNotInternetConnection() {
        delegate?.restAPINotInternetConnection(self)
    }
    
    private func notifyServerConnection(serverResponse response: DataResponse<Any>) {
        delegate?.restAPINotServerConnection(self, serverResponse: response)
    }
}
