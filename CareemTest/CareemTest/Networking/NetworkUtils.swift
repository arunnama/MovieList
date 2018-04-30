//
//  NetworkUtils.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 1/5/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit


public enum DataType {
    case JSON
    case Data
}

public protocol Request {
    var path: String  { get }
    var method: HTTPMethod   { get }
    var parameters: RequestParams  { get }
    var headers: [String: Any]?  { get }
    var dataType: DataType  { get }
}

public enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}


public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

public enum UserRequests: Request {
    
    case search(name: String,page:String)
    case imageDownload(poster_path : String)
    
    public var path: String {
        switch self {
        case .search(_,_):
            return Constants.Path.searchPath
        case .imageDownload(let poster_path):
            return Constants.Path.imagePath + poster_path
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .search(_,_):
            return .get
        case .imageDownload(_):
            return .get
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .search(let name, let page):
            return .url(
                ["api_key" : Constants.api_key,
                 "query": name,
                 "page": page])
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
        case .search(_,_):
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
}

public enum NetworkErrors: Error {
    case badInput
    case noData
}

public enum Result<Value> {
    case success(Data?)
    case failure(Error)
}

