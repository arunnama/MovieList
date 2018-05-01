//
//  HistoryDataStore.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 30/4/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

let HISTORY_COUNT = 4;

enum HistoryDataStoreError: Error {
    case EmptySaveOperation
}

class HistoryDataStore: NSObject {
    
    static func retriveHistory() -> [String] {
        guard let history = UserDefaults.standard.stringArray(forKey: "history") else { return []}
        return history.reversed();
    }
    
    static func saveSearch(_ name: String?) throws {
        guard let name = name, !name.isEmpty else {
            throw HistoryDataStoreError.EmptySaveOperation
        }
        var historyData:[String]? = UserDefaults.standard.stringArray(forKey: "history")
        if (historyData != nil) {
            if (name == historyData?.last) { return }
            
            if historyData?.count == HISTORY_COUNT {
                historyData?.removeFirst();
            }
            historyData?.append(name)
        }
        else {
            historyData = [String]()
            historyData?.append(name)
        }
        
        UserDefaults.standard.set(historyData, forKey: "history");
    }
}


