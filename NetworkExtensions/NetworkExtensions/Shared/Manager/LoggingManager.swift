//
//  File.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 25.05.20.
//  Copyright © 2020 Henrik Peters. All rights reserved.
//

import Foundation

typealias lm = LoggingManager

class LoggingManager {
    static func log(msg: String, identifier: String? = nil, logType: LogType? = .any) {
        let blockdataSettings = SharedFileManager.loadBlockdata()!.settings
        if logType! == .any {
            NSLog("\(identifier ?? "") :: \(msg)")
        }
        else if logType! == .debug {
            if blockdataSettings.log_debug {
                NSLog("\(identifier ?? "DEBUG") :: \(msg)")
            }
        }
        else if logType! == .capture {
            if blockdataSettings.log_capture {
                NSLog("\(identifier ?? "CAPTURE") :: \(msg)")
            }
        }
        else {
            NSLog("\(identifier ?? "ANY") :: \(msg)")
        }
    }
}

enum LogType : Int {
    case any = 0
    case debug = 1
    case capture = 2
}
