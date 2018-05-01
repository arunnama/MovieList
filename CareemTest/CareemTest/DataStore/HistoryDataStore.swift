//
//  HistoryDataStore.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 30/4/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

enum HistoryDataStoreError: Error {
    case EmptySaveOperation
}

class HistoryDataStore: NSObject {
    
    var dataStore:DataStore
    
    override init() {
        dataStore = DataStore.sharedInstance
    }

    func retriveHistory() -> [String] {
        guard let history = dataStore.readData(Constants.HistoryKey) else { return []}
        return history.reversed();
    }
    
    func saveSearch(_ name: String?) throws {
        guard let name = name, !name.isEmpty else {
            throw HistoryDataStoreError.EmptySaveOperation
        }
        var historyData:[String]? = dataStore.readData(Constants.HistoryKey)
        if (historyData != nil) {
            if (name == historyData?.last) { return }
            
            if historyData?.count == Constants.HISTORY_COUNT {
                historyData?.removeFirst();
            }
            historyData?.append(name)
        }
        else {
            historyData = [String]()
            historyData?.append(name)
        }
        
        dataStore.saveData(Constants.HistoryKey,historyData!);
    }
}


