//
//  Reminder.swift
//  Core
//
//  Created by Yannis De Cleene on 11/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation

public struct Reminder: Codable {
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var phone: String?
    
    public init() {}
    
    private enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case email
        case phone
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(phone, forKey: .phone)
    }
    
    public init(firstName: String,
                lastName: String,
                email: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    public init(firstName: String,
                lastName: String,
                phone: String,
                email: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
    }
}
