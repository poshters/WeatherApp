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
                if realm.objects(ProfileModels.self).count == 20 {
                    let profiles = realm.objects(ProfileModels.self)
                    profiles.forEach { realm.delete($0) }
                }
                realm.add(object, update: true)
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
                object.name = DefoultConstant.empty
                object.lastName = DefoultConstant.empty
                object.phoneNumber = DefoultConstant.empty
                object.email = DefoultConstant.empty
                object.state = State.nonsel.rawValue
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
    
    class func deleteProfileAll(object: ProfileModels) -> Bool {
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
    
}
