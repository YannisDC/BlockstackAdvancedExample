//
//  Index.swift
//  Core
//
//  Created by Yannis De Cleene on 18/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation

public struct Index: Codable {
    public var ids: [Item]
    public var date: TimeInterval?
    
    public struct Item: Codable {
        public var id: String
        public var encrypted: Bool
    }
    
    private enum CodingKeys: String, CodingKey {
        case ids
        case date
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            ids = try container.decodeIfPresent([Item].self, forKey: .ids) ?? []
        } catch {
            ids = []
            print("Doesn't decode to Item")
        }
        
        date = try container.decodeIfPresent(TimeInterval.self, forKey: .date)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(ids, forKey: .ids)
        try container.encodeIfPresent(date, forKey: .date)
    }
    
    public init(ids: [Item],
                date: TimeInterval) {
        self.ids = ids
        self.date = date
    }
    
    public mutating func push(_ id: String, encrypted: Bool) {
        ids.append(Item(id: id, encrypted: encrypted))
    }
    
    public mutating func pop(_ id: String) {
        return ids.removeAll { $0.id == id }
    }
}
