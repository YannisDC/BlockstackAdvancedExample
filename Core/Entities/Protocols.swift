//
//  Protocols.swift
//  Core
//
//  Created by Yannis De Cleene on 11/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation

protocol Identifiable {
    var uuid: String { get set }
}

protocol Cryptable {
    var encrypted: Bool { get set }
}
