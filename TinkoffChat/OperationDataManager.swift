//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 04.04.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class OperationDataManager: NSObject, DataManager {
    let queue = OperationQueue()
    let manager = FileDataManager()
    
    func saveData(_ profile: Profile, result: @escaping (Bool, Error?) -> Void) {
        let operation = SaveDataOperation(with: profile, manager: manager, result: result)
        queue.addOperation(operation)
    }
    func loadData(result: @escaping (Profile?, Error?) -> Void) {
        let operation = LoadDataOperation(with: manager, result: result)
        queue.addOperation(operation)
    }
}

class SaveDataOperation: Operation {
    
    let profile: Profile
    let result: (Bool, Error?) -> Void
    let manager: FileDataManager
    
    init(with profile: Profile, manager: FileDataManager,result: @escaping (Bool, Error?) -> Void) {
        self.profile = profile
        self.manager = manager
        self.result = result
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        do {
            try self.manager.saveProfileData(profile)
            DispatchQueue.main.async {
                self.result(true, nil)
            }
        }
        catch {
            DispatchQueue.main.async {
                self.result(false, error)
            }
        }
    }
}

class LoadDataOperation: Operation {
    let result: (Profile?, Error?) -> Void
    let manager: FileDataManager
    
    init(with manager: FileDataManager, result: @escaping (Profile?, Error?) -> Void) {
        self.result = result
        self.manager = manager
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        do {
            let profile = try self.manager.loadData()
            DispatchQueue.main.async { self.result(profile, nil) }
        }
        catch {
            DispatchQueue.main.async { self.result(nil, error) }
        }
    }
}
