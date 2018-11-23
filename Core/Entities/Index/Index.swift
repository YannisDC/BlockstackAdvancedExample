//
//  Index.swift
//  Core
//
//  Created by Yannis De Cleene on 18/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation

public struct Index: Codable {
    public var ids: [String]
    // TODO: Add optional encryption
    public var date: TimeInterval?
    
    private enum CodingKeys: String, CodingKey {
        case ids
        case date
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ids = try container.decodeIfPresent([String].self, forKey: .ids) ?? []
        date = try container.decodeIfPresent(TimeInterval.self, forKey: .date)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(ids, forKey: .ids)
        try container.encodeIfPresent(date, forKey: .date)
    }
    
    public init(ids: [String],
                date: TimeInterval) {
        self.ids = ids
        self.date = date
    }
    
    public mutating func push(_ id: String) {
        ids.append(id)
    }
    
    public mutating func pop(_ id: String) {
        return ids.removeAll { $0 == id }
    }
}
