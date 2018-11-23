//
//  Event.swift
//  Core
//
//  Created by Yannis De Cleene on 11/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation

public enum EventType: String, Codable {
    case surprise = "LightBlueColor"
    case reminder = "OrangeColor"
    case date = "GreenColor"
    case special = "RedColor"
}

public enum RepeatSize: String, Codable {
    case weeks = "week(s)"
    case months = "month(s)"
    case years = "year(s)"
}

public struct Event: Codable {
    public var eventType: EventType?
    public var name: String?
    public var description: String? // Optional
    public var date: Date?
    public var location: String? // Optional
    public var repeatCount: Int = 0
    public var repeatSize: RepeatSize = .weeks
    public var id: String?
    
    public func setNotification() {}
    
    public init() {}
    
    private enum CodingKeys: String, CodingKey {
        case eventType
        case name
        case description
        case date
        case location
        case repeatCount
        case repeatSize
        case id
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventType = try container.decodeIfPresent(EventType.self, forKey: .eventType)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        date = try container.decodeIfPresent(Date.self, forKey: .date)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        repeatCount = try container.decodeIfPresent(Int.self, forKey: .repeatCount) ?? 0
        repeatSize = try container.decodeIfPresent(RepeatSize.self, forKey: .repeatSize) ?? .weeks
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(eventType, forKey: .eventType)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(repeatCount, forKey: .repeatCount)
        try container.encodeIfPresent(repeatSize, forKey: .repeatSize)
        try container.encodeIfPresent(id, forKey: .id)
        
    }
    
    public init(eventType: EventType,
                name: String,
                description: String,
                date: Date,
                location: String,
                repeatCount: Int,
                repeatSize: RepeatSize,
                id: String) {

        self.eventType = eventType
        self.name = name
        self.description = description
        self.date = date
        self.location = location
        self.repeatCount = repeatCount
        self.repeatSize = repeatSize
        self.id = id
    }
}
