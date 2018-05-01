//
//  MovieResult.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 1/5/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

struct MovieResults: Codable {
    let page : Int
    let total_results : Int
    let total_pages : Int
    let results : [Movie]?
    /*
    init(page:Int,total_results:Int, total_pages: Int, results: [Movie]?) {
        self.page = page
        self.total_results = total_results
        self.total_pages = total_pages
        self.results = results
    }
 */
    init() {
        self.page = 0
        self.total_results = 0
        self.total_pages = 0
        self.results = [];
    }
}
