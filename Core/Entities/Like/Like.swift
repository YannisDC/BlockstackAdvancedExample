//
//  Like.swift
//  Core
//
//  Created by Yannis De Cleene on 11/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation

protocol Identifiable {
    var uuid: String { get set }
}

protocol Cryptable {
    var encrypted: Bool { get set }
}

public struct Like: Codable, Identifiable, Cryptable {
    public var description: String?
    public var image: UIImage? // Optional
    public var tags: [String]?
    public var uuid: String
    public var encrypted: Bool
    // TODO: Add updated: Date
    
    private enum CodingKeys: String, CodingKey {
        case description
        case image
        case tags
        case uuid
        case encrypted
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        let imageDataBase64String = try container.decode(String.self, forKey: .image)
        if let data = Data(base64Encoded: imageDataBase64String) {
            image = UIImage(data: data)
        } else {
            image = nil
        }
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? UUID().uuidString
        encrypted = try container.decodeIfPresent(Bool.self, forKey: .encrypted) ?? false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(description, forKey: .description)
        if let image = image, let imageData = image.pngData() {
            let imageDataBase64String = imageData.base64EncodedString()
            try container.encode(imageDataBase64String, forKey: .image)
        }
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(uuid, forKey: .uuid)
        try container.encodeIfPresent(encrypted, forKey: .encrypted)
    }
    
    public init(description: String,
                image: UIImage?,
                tags: [String],
                uuid: String = UUID().uuidString,
                encrypted: Bool = false) {
        
        self.description = description
        self.image = image
        self.tags = tags
        self.uuid = uuid
        self.encrypted = encrypted
    }
}
