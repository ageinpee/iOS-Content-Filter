//
//  SharedFileManager.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 17.05.20.
//  Copyright © 2020 Henrik Peters. All rights reserved.
//

import Foundation

class SharedFileManager: FileManager {
    
    static func sharedContainerURL() -> URL {
      return FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: "group.com.research.NetworkExtensions"
      )!
    }
    
    static func loadBlockdata() -> ForbiddenData? {
        let dir = self.sharedContainerURL()
        let sharedURL = dir.appendingPathComponent("blockdata.json")
        // reading
        do {
            let data = try Data(contentsOf: sharedURL)
            _ = try! JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            let blockdata = try JSONDecoder().decode(ForbiddenData.self, from: data)
//            lm.log(msg: "shared ressource blockdata data loaded", identifier: "SharedRessourceIdentifier", logType: .debug)
            return blockdata
        } catch {
            // try load bundle-data if shared-data fails
            let bundleURL = Bundle.main.url(forResource: "blockdata", withExtension: "json")!
            let bundleData = try! Data(contentsOf: bundleURL)
//            lm.log(msg: "bundle ressource blockdata data loaded", identifier: "SharedRessourceIdentifier", logType: .debug)
            try! bundleData.write(to: sharedURL) // writes bundle-data into shared data
            do {
                return try JSONDecoder().decode(ForbiddenData.self, from: bundleData)
            } catch {
//                lm.log(msg: "loading blockdata failed completely", identifier: "SharedRessourceIdentifier", logType: .debug)
                return nil
            }
        }
    }
    
    static func saveBlockdata(data: ForbiddenData, then: ()->Void = {}, fail: ()->Void = {}, finally: ()->Void = {}) {
        if let encodedData = try? JSONEncoder().encode(data) {
            let dir = self.sharedContainerURL()
            let fileURL = dir.appendingPathComponent("blockdata.json")
            do {
                try encodedData.write(to: fileURL)
                then()
//                lm.log(msg: "writing blockdata complete", identifier: "SharedRessourceIdentifier", logType: .debug)
            }
            catch {
                fail()
//                lm.log(msg: "writing blockdata failed", identifier: "SharedRessourceIdentifier", logType: .debug)
            }
        }
        finally()
    }
    
    static func loadIntercepted() -> InterceptedData? {
        let dir = self.sharedContainerURL()
        let sharedURL = dir.appendingPathComponent("intercepted.json")
        //reading
        do {
            let data = try Data(contentsOf: sharedURL)
            _ = try! JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            let intercepted = try JSONDecoder().decode(InterceptedData.self, from: data)
//            lm.log(msg: "shared ressource blockdata data loaded", identifier: "SharedRessourceIdentifier", logType: .debug)
            return intercepted
        } catch {
            // create new intercepted.json in shared ressource
            let newInterceptedData = try! JSONEncoder().encode(InterceptedData())
            try! newInterceptedData.write(to: sharedURL)
            // return new InterceptedData
            return InterceptedData()
        }
    }
    
    static func writeIntercepted(data: InterceptedData, then: ()->Void = {}, fail: ()->Void = {}, finally: ()->Void = {}) {
        if let encodedData = try? JSONEncoder().encode(data) {
            let dir = self.sharedContainerURL()
            let fileURL = dir.appendingPathComponent("intercepted.json")
            do {
                try encodedData.write(to: fileURL)
                then()
//                lm.log(msg: "writing interceptedData complete", identifier: "SharedRessourceIdentifier", logType: .debug)
            }
            catch {
                fail()
//                lm.log(msg: "writing interceptedData failed", identifier: "SharedRessourceIdentifier", logType: .debug)
            }
        }
        finally()
    }
}
