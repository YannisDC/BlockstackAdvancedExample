//
//  URL+Ext.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 29/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation

extension URL {
    mutating func appendingPathComponent(username: String?) {
        if let username = username {
            self.appendPathComponent(username)
        }
    }
}
