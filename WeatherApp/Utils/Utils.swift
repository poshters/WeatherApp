//
//  Utils.swift
//  WeatherApp
//
//  Created by mac on 10/1/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
