//
//  Movie.swift
//  MovieTest
//
//  Created by idpmobile on 24/4/18.
//  Copyright © 2018 idpmobile. All rights reserved.
//

import UIKit
import Foundation

struct Movie : Codable {
    
    let poster_path: String?
    let title: String
    let release_date: String
    let overview: String
    
    init(poster: String?, name: String, releaseDate: String,overview: String){
        self.poster_path = poster;
        self.title = name;
        self.release_date = releaseDate;
        self.overview = overview;
    }
}

