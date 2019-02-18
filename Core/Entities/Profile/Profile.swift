//
//  Profile.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 09/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation

public struct Profile: Codable, Identifiable, Cryptable {
    public var personType: PersonType
    public var maritialStatus: MaritialStatus
    public var birthday: Date
    public var anniversary: Date
    public var reminders: Reminders
    public var uuid: String = "0"
    public var encrypted: Bool
    // TODO: Add updated: Date
    
    private enum CodingKeys: String, CodingKey {
        case personType
        case maritialStatus
        case birthday
        case anniversary
        case reminders
        case uuid
        case encrypted
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        personType = try container.decodeIfPresent(PersonType.self, forKey: .personType) ?? .playItCool
        maritialStatus = try container.decodeIfPresent(MaritialStatus.self, forKey: .maritialStatus) ?? .relationship
        birthday = try container.decodeIfPresent(Date.self, forKey: .birthday) ?? Date()
        anniversary = try container.decodeIfPresent(Date.self, forKey: .anniversary) ?? Date()
        reminders = try container.decodeIfPresent(Reminders.self, forKey: .reminders) ?? Reminders()
        encrypted = try container.decodeIfPresent(Bool.self, forKey: .encrypted) ?? true
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(personType, forKey: .personType)
        try container.encodeIfPresent(maritialStatus, forKey: .maritialStatus)
        try container.encodeIfPresent(birthday, forKey: .birthday)
        try container.encodeIfPresent(anniversary, forKey: .anniversary)
        try container.encodeIfPresent(reminders, forKey: .reminders)
        try container.encodeIfPresent(uuid, forKey: .uuid)
        try container.encodeIfPresent(encrypted, forKey: .encrypted)
    }
    
    public init(personType: PersonType,
                maritialStatus: MaritialStatus,
                birthday: Date,
                anniversary: Date,
                reminders: Reminders,
                encrypted: Bool = true) {
        
        self.personType = personType
        self.maritialStatus = maritialStatus
        self.birthday = birthday
        self.anniversary = anniversary
        self.reminders = reminders
        self.encrypted = encrypted
    }
}

public struct Reminders: Codable {
    public var notifications: Bool = false
    public var birthdayReminder: Bool = false
    public var anniversaryReminder: Bool = false
    public var marriageReminder: Bool = false
    public var surprisesReminder: Bool = false
    public var flowersReminder: Bool = false
    
    public init() {}
    
    mutating func setDonJuan() {
        notifications = true
        birthdayReminder = true
        anniversaryReminder = true
        marriageReminder = true
        surprisesReminder = true
        flowersReminder = true
    }
    
    mutating func setPlayItCool() {
        notifications = true
        birthdayReminder = true
        anniversaryReminder = true
        marriageReminder = false
        surprisesReminder = false
        flowersReminder = true
    }
    
    mutating func setIDontCare() {
        notifications = true
        birthdayReminder = true
        anniversaryReminder = false
        marriageReminder = false
        surprisesReminder = false
        flowersReminder = false
    }
}

public enum PersonType: String, Codable {
    case donJuan = "donJuan"
    case playItCool = "playItCool"
    case iDontCare = "iDontCare"
    
    private enum Key: CodingKey {
        case rawValue
    }
    
    private enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .donJuan
        case 1:
            self = .playItCool
        case 2:
            self = .iDontCare
        default:
            throw CodingError.unknownValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .donJuan:
            try container.encode(0, forKey: .rawValue)
        case .playItCool:
            try container.encode(1, forKey: .rawValue)
        case .iDontCare:
            try container.encode(2, forKey: .rawValue)
        }
    }
}

public enum MaritialStatus: String, Codable {
    case married = "married"
    case livingTogether = "livingTogether"
    case relationship = "relationship"
    
    private enum Key: CodingKey {
        case rawValue
    }
    
    private enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .married
        case 1:
            self = .livingTogether
        case 2:
            self = .relationship
        default:
            throw CodingError.unknownValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .married:
            try container.encode(0, forKey: .rawValue)
        case .livingTogether:
            try container.encode(1, forKey: .rawValue)
        case .relationship:
            try container.encode(2, forKey: .rawValue)
        }
    }
}
