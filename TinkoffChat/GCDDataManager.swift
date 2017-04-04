//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 04.04.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class GCDDataManager: NSObject, DataManager {
    var manager = FileDataManager()
    let queue = DispatchQueue(label: "dataManagerQueue")
    
    func saveData(_ profile: Profile, result: @escaping (Bool, Error?) -> Void) {
        queue.async {
            do {
                try self.manager.saveProfileData(profile)
                DispatchQueue.main.async { result(true, nil) }
            }
            catch {
                DispatchQueue.main.async { result(false, error) }
            }
        }
    }
    func loadData(result: @escaping (Profile?, Error?) -> Void) {
        queue.async {
            do {
                let profile = try self.manager.loadData()
                DispatchQueue.main.async { result(profile, nil) }
            }
            catch {
                DispatchQueue.main.async { result(nil, error) }
            }
        }
    }
}
