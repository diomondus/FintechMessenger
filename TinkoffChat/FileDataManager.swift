//
//  FileDataManager.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 04.04.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

protocol DataManager {
    // сохранение данных профиля
    func saveData(_ profile: Profile, result: @escaping (Bool, Error?) -> Void)
    // загрузка данных профиля
    func loadData(result: @escaping (Profile?, Error?) -> Void)
}

class FileDataManager {
    
    func saveProfileData(_ profile: Profile) throws {
        let dataDicionary = serializeData(profile)
        let data = NSKeyedArchiver.archivedData(withRootObject: dataDicionary)
        try data.write(to: getFilePath())
    }
    
    func loadData() throws -> Profile? {
        var profile: Profile?
        guard FileManager.default.fileExists(atPath: getFilePath().path) else {
            throw FileDeserializingError.somethingWrong
        }
        let data = try Data(contentsOf: getFilePath())
        profile = try deserializeData(data)        
        return profile
    }
    
    func serializeData(_ profile: Profile) -> Dictionary<String, Any> {
        let imageData = NSKeyedArchiver.archivedData(withRootObject: profile.image)
        let textColorData = NSKeyedArchiver.archivedData(withRootObject: profile.textColor)
        
        return [FileDataManager.NAMEKEY: profile.name, FileDataManager.ABOUTKEY: profile.about,
                FileDataManager.IMAGEKEY: imageData, FileDataManager.TEXTCOLORKEY: textColorData]
    }
    
    func deserializeData(_ data: Data) throws -> Profile? {
        guard let map = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any] else {
            throw FileDeserializingError.somethingWrong
        }
        guard let name = map[FileDataManager.NAMEKEY] as? String else {
            throw FileDeserializingError.somethingWrong
        }
        guard let about = map[FileDataManager.ABOUTKEY] as? String else {
            throw FileDeserializingError.somethingWrong
        }
        guard let image = NSKeyedUnarchiver.unarchiveObject(
            with: map[FileDataManager.IMAGEKEY] as! Data) as? UIImage else {
            throw FileDeserializingError.somethingWrong
        }
        guard let textColor = NSKeyedUnarchiver.unarchiveObject(
            with: map[FileDataManager.TEXTCOLORKEY] as! Data) as? UIColor else {
            throw FileDeserializingError.somethingWrong
        }
        return Profile(name: name, about: about, textColor: textColor, image: image)
    }

    func getFilePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(FileDataManager.FILENAMEKEY)
    }
    
    enum FileDeserializingError: Error {
        case somethingWrong
    }
    
    static let IMAGEKEY = "IMAGEKEY"
    static let NAMEKEY = "NAMEKEY"
    static let ABOUTKEY = "ABOUTKEY"
    static let TEXTCOLORKEY = "TEXTCOLORKEY"
    static let FILENAMEKEY = "FILENAMEKEY"
}
