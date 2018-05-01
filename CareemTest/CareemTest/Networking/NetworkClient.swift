//
//  NetworkClient.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 29/4/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

public class NetworkDispatcher {
    
    private var environment: Environment
    private var session: URLSession
    public init(name: String, host:String) {
        self.environment = Environment(name, host: host)
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public func execute(request: Request, completion: ((Result<Any>) -> Void)?) {
        
        do {
            let rq = try self.prepareURLRequest(for: request)
            let task = self.session.dataTask(with: rq) { (responseData, response, responseError) in
                DispatchQueue.main.async {
                    if let error = responseError {
                        completion?(.failure(error))
                    } else if ((responseData) != nil) {
                        completion?(.success(responseData))
                    } else {
                        let error = NSError(domain: "Network", code: 10000, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                        completion?(.failure(error))
                    }
                }
            }
            task.resume()
        }catch {
            let error = NSError(domain: "Network", code: 10000, userInfo: [NSLocalizedDescriptionKey : "Error in Network api"]) as Error
            completion?(.failure(error))
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
