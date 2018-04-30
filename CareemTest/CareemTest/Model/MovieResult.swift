//
//  MovieResult.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 1/5/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

struct MovieResults: Codable {
    let page = 1;
    let total_results = 0
    let total_pages = 0
    let results : [Movie] = []
}
