//
//  DataStore.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 1/5/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

class DataStore: NSObject {
    
    static let sharedInstance = DataStore()
    
    private override init() {
        print("DataStoreHelloWOrld")
    }
    func saveData(_ key:String, _ value:[String]) {
       UserDefaults.standard.set(value, forKey: key);
    }
    
    func readData(_ key:String) -> [String]?{
        return UserDefaults.standard.stringArray(forKey: key)
    }
}

