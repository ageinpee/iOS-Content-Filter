//
//  TrackerManager.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 21.05.20.
//  Copyright © 2020 Henrik Peters. All rights reserved.
//

import Foundation

class TrackerManager {
    static func isTracker(url: String) -> Bool {
        let forbiddenUrls = SharedFileManager.loadBlockdata()!.blocklist
        var isTracker = false
        for forbiddenUrl in forbiddenUrls {
            if url.contains(forbiddenUrl) {
                isTracker = true
            }
        }
        return isTracker
    }
}
