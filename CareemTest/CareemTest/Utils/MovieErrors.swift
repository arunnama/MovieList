//
//  MovieErrors.swift
//  MovieTest
//
//  Created by Arun Kumar Nama on 27/4/18.
//

import UIKit

enum MovieError : Error  {
    case EmptyName 
    case EmptyPoster
    case NoMoviesFound
    case NetworkError
    case InvalidData
    case Unknown
    
    public var title: String {
        switch self {
        case .EmptyName:
            return "Emtpty Name"
        case .EmptyPoster:
            return "Empty Poster Error"
        case .NoMoviesFound:
            return "No Movies found Error"
        case .NetworkError:
            return "Connection Error"
        case .InvalidData:
            return "Invalid Data Error"
        case .Unknown:
            return "Unknow error"
        }
    }
    
    public var message: String {
        switch self {
        case .EmptyName:
            return "Emtpty Name is found in search"
        case .EmptyPoster:
            return "There is no poster for this movie"
        case .NoMoviesFound:
            return "No Movies found for this movie title. Please search for any other"
        case .NetworkError:
            return "Connection has some error. Please try later"
        case .InvalidData:
            return "Invalid data is received from server. Please try later"
        case .Unknown:
            return "Unknow error is found. please try again."
        }
    }
}
