//
//  ProfileDBManager.swift
//  WeatherApp
//
//  Created by MacBook on 11/7/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RealmSwift

class ProfileDBManager {
    
    @discardableResult
    class func addDBProfile(object: ProfileModels) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                if realm.objects(ProfileModels.self).isEmpty {
                    realm.add(object, update: true)
                }
            }
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    class func deleteProfile(object: ProfileModels) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                let profiles = realm.objects(ProfileModels.self)
                profiles.forEach { realm.delete($0) }
            }
            return true
        } catch {
            return false
        }
    }
    
    class func getProfile() -> Results<ProfileModels>? {
        do {
            let realm = try Realm()
            let result = realm.objects(ProfileModels.self)
            return result
        } catch {
            return nil
        }
    }
}
