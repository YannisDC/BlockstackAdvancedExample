//
//  JSONSerialisation+Extension.swift
//  Core
//
//  Created by Yannis De Cleene on 05/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import UIKit

let payloadKey: String = "payload"

extension JSONSerialization {
    
    // Parse payload object from Mobile Support data
    class func payloadJSONObject(with data: Data) -> [String: Any]? {
        do {
            guard let jsonData = try jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                print("⚠️ Failed to parse JSON")
                return nil
            }
            
            guard let payloadData = jsonData[payloadKey] as? [String: Any] else {
                print("⚠️ No payload data found in JSON")
                return nil
            }
            return payloadData
        } catch {
            return nil
        }
    }
}
