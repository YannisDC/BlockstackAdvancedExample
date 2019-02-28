//
//  DeepLinkOption.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 25/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation

struct DeepLinkURLConstants {
    static let addEvent = "addEvent"
    static let likeName = "likeName"
}

enum DeepLinkOption {
    case home
    case addEvent(url: URL)
    case addLike(name: String)
    
    static func build(with userActivity: NSUserActivity) -> DeepLinkOption? {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL else {
                return nil
        }
        
        return build(from: url)
    }
    
    static func build(from url: URL) -> DeepLinkOption? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        if let scheme = urlComponents.scheme,
            scheme == "perfectdude" {
            return parseOnboardingDeepLink(in: url)
        }
        
        guard let firstComponent = firstComponent(from: urlComponents) else {
            return nil
        }
        
        // Get deeplink option
        switch firstComponent.lowercased() {
        case DeepLinkURLConstants.addEvent:
            return DeepLinkOption.addEvent(url: url)
        default:
            return DeepLinkOption.home
        }
    }
    
    static func build(with dict: [String: AnyObject]?) -> DeepLinkOption? {
        // Here we can trigger a deeplink that comes from a remote or local notification
        return nil
    }
}

// MARK: - Private

private extension DeepLinkOption {
    static func firstComponent(from urlComponents: URLComponents) -> String? {
        return urlComponents.path.components(separatedBy: "/")
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .first
    }
    
    static func value(forQueryItem queryItem: String, in url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let items = components.queryItems else { return nil }
        
        return items.first { $0.name.lowercased() == queryItem.lowercased() }?.value
    }
    
    static func parseOnboardingDeepLink(in url: URL) -> DeepLinkOption? {

        
        if let likeName = value(forQueryItem: DeepLinkURLConstants.likeName, in: url) {
            return DeepLinkOption.addLike(name: likeName)
        }
        
        return nil
    }
}
