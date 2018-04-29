//
//  NetworkClient.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 29/4/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit


public enum DataType {
    case JSON
    case Data
}

public protocol Request {
    var path            : String                { get }
    var method        : HTTPMethod            { get }
    var parameters    : RequestParams            { get }
    var headers        : [String: Any]?        { get }
    var dataType        : DataType                { get }
}

public enum HTTPMethod: String {
    case post            = "POST"
    case put                = "PUT"
    case get                = "GET"
    case delete            = "DELETE"
    case patch            = "PATCH"
}


public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

public enum UserRequests: Request {
    
    case search(name: String)
    case imageDownload(poster_path : String)
    
    public var path: String {
        switch self {
        case .search(_):
            return Constants.Path.searchPath
        case .imageDownload(let poster_path):
            return Constants.Path.imagePath + poster_path
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .search(_):
            return .get
        case .imageDownload(_):
            return .get
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .search(let name):
            return .url(
                ["api_key" : Constants.api_key,
                 "query": name,
                 "page":"1"])
        case .imageDownload(_):
            return .url(
                [:])
        }
        
        
    }
    
    
    public var headers: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    public var dataType: DataType {
        switch self {
        case .search(_):
            return .JSON
        case .imageDownload:
            return .Data
        }
    }
}

public struct Environment {
    
    public var name: String
    
    public var host: String
    
    public var headers: [String: Any] = [:]
    
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    public init(_ name: String, host: String) {
        self.name = name
        self.host = host
    }
    
    //    http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=batman&page=1
    
}



public enum NetworkErrors: Error {
    case badInput
    case noData
}

public enum Result<Value> {
    case success(Data?)
    case failure(Error)
}

public class NetworkDispatcher {
    
    private var environment: Environment
    private var session: URLSession
    public init(name: String, host:String) {
        self.environment = Environment(name, host: host)
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public func execute(request: Request, completion: ((Result<Data>) -> Void)?) {
        do {
            let rq = try self.prepareURLRequest(for: request) //TODO Handle error
            let task = self.session.dataTask(with: rq) { (responseData, response, responseError) in
                DispatchQueue.main.async {
                    if let error = responseError {
                        completion?(.failure(error))
                    } else if ((responseData) != nil) {
                        completion?(.success(responseData))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                        completion?(.failure(error))
                    }
                }
            }
            
            task.resume()
        }catch {
            
        }
    }
    
    private func prepareURLRequest(for request: Request) throws -> URLRequest {
        // Compose the url
        let full_url = "\(environment.host)/\(request.path)"
        var url_request = URLRequest(url: URL(string: full_url)!)
        
        // Working with parameters
        switch request.parameters {
        case .body(let params):
            // Parameters are part of the body
            if let params = params as? [String: String] { // just to simplify
                url_request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
            } else {
                throw NetworkErrors.badInput
            }
        case .url(let params):
            // Parameters are part of the url
            if let params = params as? [String: String] { // just to simplify
                let query_params = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                guard var components = URLComponents(string: full_url) else {
                    throw NetworkErrors.badInput
                }
                components.queryItems = query_params
                url_request.url = components.url
            } else {
                throw NetworkErrors.badInput
            }
        }
        
        // Add headers from enviornment and request
        environment.headers.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        
        // Setup HTTP method
        url_request.httpMethod = request.method.rawValue
        
        return url_request
    }
}
