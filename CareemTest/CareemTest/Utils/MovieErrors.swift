//
//  MovieErrors.swift
//  MovieTest
//
//  Created by Arun Kumar Nama on 27/4/18.
//

import UIKit

class MovieErrors: Error {

    
}

enum MovieError : Error {
    case EmptyName 
    case EmptyPoster
    case NoMoviesFound
    case Unknown
    
    public var title: String {
        switch self {
        case .EmptyName:
            return "Emtpty Name"
        case .EmptyPoster:
            return "Empty Poster Error"
        case .NoMoviesFound:
            return "No Movies found Error"
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
        case .Unknown:
            return "Unknow error is found. please try again."
        }
    }
}
