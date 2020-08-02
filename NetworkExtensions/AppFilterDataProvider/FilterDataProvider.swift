//
//  FilterDataProvider.swift
//  AppFilterDataProvider
//
//  Created by Henrik Peters on 31.12.19.
//  Copyright © 2019 Henrik Peters. All rights reserved.
//

import NetworkExtension

class FilterDataProvider: NEFilterDataProvider {
    //var cdm: CoreDataManager? = try! CoreDataManager()
    let df: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd'T'H:m:ss.SSS ZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
    
    // MARK: - overrides
    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        lm.log(msg: "FilterDataProvider_Identifier :: started filter", logType: .debug)
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        lm.log(msg: "FilterDataProvider_Identifier :: stopped filter", logType: .debug)
        completionHandler()
    }
    
    override func handleNewFlow(_ flow: NEFilterFlow) -> NEFilterNewFlowVerdict {
        for log in self.formatFlowData(flow) {
            lm.log(msg: log, identifier: "msg-identifer-xxx -", logType: .capture)
        }
        let url = flow.url?.absoluteString ?? ""
        NSLog("msg-identifer-xxx - request ControlProviders decision for: \(url)")
        return .needRules()
        
    }
    
    // MARK: - private helpers
    
    private func formatFlowData(_ flow: NEFilterFlow) -> [String] {
        var newEntry = flowEntry()
        let d = Date()
        newEntry.timestamp = self.df.string(from: d)
        if #available(iOSApplicationExtension 13.1, *) {
            newEntry.identifier = flow.identifier.uuidString
        } else {
            newEntry.identifier = UUID().uuidString
        }
        newEntry.url = flow.url?.absoluteString ?? "ERROR :: cannot access url"
        newEntry.sourceAppIdentifier = flow.sourceAppIdentifier!
        newEntry.sourceAppUniqueIdentifier = flow.sourceAppUniqueIdentifier?.base64EncodedString() ?? "ERROR :: cannot access sourceAppUniqueIdentifier"
        newEntry.sourceAppVersion = flow.sourceAppVersion!
        if flow is NEFilterBrowserFlow {
            newEntry.flowDataType = "NEFilterBrowserFlow"
        }
        else if flow is NEFilterSocketFlow {
            newEntry.flowDataType = "NEFilterSocketFlow"
        }
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(newEntry)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        let unwrappedJson = json!
        if unwrappedJson.count <= 400 {
            let singlePackage = package(log_id: UUID().uuidString, packages: 1, package_index: 0, data: unwrappedJson)
            let singlePackageJson = try! jsonEncoder.encode(singlePackage)
            return [String(data: singlePackageJson, encoding: String.Encoding.utf8)!]
        } else {
            var result: [String] = []
            let multipleData = unwrappedJson.split(by: 400)
            let logId = UUID().uuidString
            for (index, data) in multipleData.enumerated() {
                let onePackage = package(log_id: logId, packages: multipleData.count, package_index: index, data: data)
                let onePackageJson = try! jsonEncoder.encode(onePackage)
                result.append(String(data: onePackageJson, encoding: String.Encoding.utf8)!)
            }
            return result
        }
    }
    
    private func formatFlowData(_ flow: NEFilterBrowserFlow) -> String {
        return "flowType: NEFilterBrowserFlow"
    }
    
    private func formatFlowData(_ flow: NEFilterSocketFlow) -> String {
        return "flowtype: NEFilterSocketFlow"
        
    }
}

struct package: Codable {
    var log_id = ""
    var packages = 1
    var package_index = 0
    var data = ""
}

struct flowEntry: Codable {
    var timestamp = ""
    var identifier = ""
    var url = ""
    var sourceAppIdentifier = ""
    var sourceAppUniqueIdentifier = ""
    var sourceAppVersion = ""
    var flowDataType = ""
}

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
}
