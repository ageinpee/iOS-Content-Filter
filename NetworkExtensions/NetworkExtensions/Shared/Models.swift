//
//  ForbiddenData.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 16.05.20.
//  Copyright © 2020 Henrik Peters. All rights reserved.
//

import Foundation
import NetworkExtension

struct InterceptedData: Codable {
    var urllist: [InterceptedUrl] = []
}

struct InterceptedUrl: Codable, Equatable {
    var url: String = ""
    var isTracker: Bool = false
    var count: Int = 0
    
    var timestamp: Date = Date()
    var sourceAppUniqueIdentifier: Data?
    var sourceAppIdentifier: String?
    var sourceAppVersion: String?
    
    init() {}
    
    init(flow: NEFilterFlow) {
        self.url = flow.url?.absoluteString ?? ""
        self.isTracker = self.url != "" ? TrackerManager.isTracker(url: flow.url!.absoluteString) : false
        self.count = 1
        self.timestamp = Date()
        self.sourceAppUniqueIdentifier = flow.sourceAppUniqueIdentifier
        self.sourceAppIdentifier = flow.sourceAppIdentifier
        self.sourceAppVersion = flow.sourceAppVersion
    }
    
    static func == (lhs: InterceptedUrl, rhs: InterceptedUrl) -> Bool {
        return lhs.url == rhs.url
            && lhs.sourceAppIdentifier == rhs.sourceAppIdentifier
            && lhs.timestamp == rhs.timestamp
    }
    
    static func sameUrl(lhs: InterceptedUrl, rhs: InterceptedUrl) -> Bool {
        return lhs.url == rhs.url
    }
}

struct ForbiddenData: Codable {
    var settings: Setting = Setting()
    var blocklist: [String] = []
}

struct Setting: Codable {
    var log_allowed: Bool = false // deprecated
    var log_blocked: Bool = true // deprecated
    var log_capture: Bool = true
    var log_debug: Bool = true
    var shall_block: Bool = true
}
