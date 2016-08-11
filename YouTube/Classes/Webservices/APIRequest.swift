//
//  APIRequest.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import Alamofire

// Common status codes
enum APIStatusCode: Int {
    case SUCCESS = 200
    case CREATED = 201
    case ACCEPTED = 202
    case UNAUTHORIZED = 401
    case INTERNALSERVER = 500
    case MAINTENANCE = 503
    case UNKNOWN = 1001
}

struct APIError {
    var code: Int!
    var domain: String = "" // Separate with Alamofire defined error domain
    var type: String?
    var message: String?

    init(code: Int!, domain: String?, type: String?, message: String?) {
        self.code = code
        if let domain = domain {
            self.domain = domain
        }
        self.type = type
        self.message = message
    }
}

typealias APIRequestSuccess = (response: AnyObject?) -> Void
typealias APIRequestFailure = (error: APIError?) -> Void
typealias APIRequestCompletion = (success: Bool,nextPageToken: String?, error: APIError?) -> Void

class APIRequest {

    static let manager = NetworkReachabilityManager(host: "www.apple.com")

    // MARK: Private class methods

    class func request(method: Alamofire.Method,
        api: String,
        parameter: [String: AnyObject]?,
        success: APIRequestSuccess,
        failure: APIRequestFailure) -> Void {
            if let manager = manager {
                if !manager.isReachable {
                    let message = "The network was lost"
                    let error = APIError(code: APIStatusCode.UNKNOWN.rawValue, domain: nil, type: nil, message: message)
                    failure(error: error)
                    return
                }
            }
            var parameters = [String: AnyObject]()
            if let parameter = parameter {
                parameters = parameter
            }
            parameters["key"] = AppDefine.YoutubeKey

            let encode = method == .GET ? ParameterEncoding.URL : ParameterEncoding.JSON
            var headers: [String: String]? = [String: String]()
            headers!["Content-Type"] = "application/x-www-form-urlencoded"

            Alamofire.request(method, api, parameters: parameters, encoding: encode, headers: headers)
                .responseJSON { (response) -> Void in
                    if response.result.isSuccess {
                        if let value = response.result.value as? NSDictionary {
                            success(response: value)
                        } else {
                            let error = response.result.error
                            let message = error?.localizedDescription
                            let returnError = APIError(code: error?.code, domain: error?.domain, type: nil, message: message)
                            failure(error: returnError)
                        }
                    } else {
                        let error = response.result.error
                        let message = error?.localizedDescription
                        let returnError = APIError(code: error?.code, domain: error?.domain, type: nil, message: message)
                        failure(error: returnError)
                    }
            }
    }

    class func checkNetwork() {

        manager?.listener = { (status: NetworkReachabilityManager.NetworkReachabilityStatus) -> Void in
            switch status {
            case .Unknown:
                break
            case .NotReachable:
                break
            case .Reachable(NetworkReachabilityManager.ConnectionType.EthernetOrWiFi):
                break
            case .Reachable(NetworkReachabilityManager.ConnectionType.WWAN):
                break
            }
        }
        manager?.startListening()
    }

    // MARK: Public class methods

    class func POST(api: String, parameters: [String: AnyObject]?, success: APIRequestSuccess, failure fail: APIRequestFailure) -> Void {
        request(.POST, api: api, parameter: parameters, success: success, failure: fail)
    }

    class func GET(api: String, parameter: [String: AnyObject]?, success: APIRequestSuccess, failure fail: APIRequestFailure) -> Void {
        request(.GET, api: api, parameter: parameter, success: success, failure: fail)
    }

    class func PUT(api: String, parameters: [String: AnyObject]?, success: APIRequestSuccess, failure fail: APIRequestFailure) -> Void {
        request(.PUT, api: api, parameter: parameters, success: success, failure: fail)
    }

    class func DELETE(api: String, parameters: [String: AnyObject]?, success: APIRequestSuccess, failure fail: APIRequestFailure) -> Void {
        request(.DELETE, api: api, parameter: parameters, success: success, failure: fail)
    }
}
