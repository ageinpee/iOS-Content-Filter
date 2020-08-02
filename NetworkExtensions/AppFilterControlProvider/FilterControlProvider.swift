//
//  FilterControlProvider.swift
//  AppFilterControlProvider
//
//  Created by Henrik Peters on 31.12.19.
//  Copyright © 2019 Henrik Peters. All rights reserved.
//

import NetworkExtension

class FilterControlProvider: NEFilterControlProvider {
    
    var blockdata: ForbiddenData? = ForbiddenData()
    
    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        lm.log(msg: "FilterControlProvider_Identifier :: started filter", logType: .debug)
        self.blockdata = SharedFileManager.loadBlockdata()
        lm.log(msg: "blocklist loaded: \(self.blockdata?.blocklist ?? ["failed loading"])", logType: .debug)
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        lm.log(msg: "FilterControlProvider_Identifier :: stopped filter", logType: .debug)
        completionHandler()
    }
    
    override func handleNewFlow(_ flow: NEFilterFlow, completionHandler: @escaping (NEFilterControlVerdict) -> Void) {
        self.blockdata = SharedFileManager.loadBlockdata()
        let url = flow.url?.absoluteString ?? ""
        let newInterceptedUrl = InterceptedUrl(flow: flow)
        var currentIntercepted = SharedFileManager.loadIntercepted()!
        if let index = currentIntercepted.urllist.firstIndex(where: { $0 == newInterceptedUrl}) {
            currentIntercepted.urllist[index].count += 1
            lm.log(msg: "FilterControlProvider_Identifier :: encountered already existing url \(currentIntercepted.urllist[index].count)", logType: .debug)
            SharedFileManager.writeIntercepted(data: currentIntercepted)
        }
        else {
            currentIntercepted.urllist.append(newInterceptedUrl)
            SharedFileManager.writeIntercepted(data: currentIntercepted)
        }
        
        if !(blockdata?.settings.shall_block ?? false) {
            lm.log(msg: "FilterControlProvider_Identifier :: Blocking is off. Allowed flow.", logType: .debug)
            completionHandler(.allow(withUpdateRules: false))
            return
        }
        else
        {
            if url != "" {
                for forbiddenUrl in self.blockdata!.blocklist {
                    if url.contains(forbiddenUrl) {
                        if (self.blockdata?.settings.log_blocked)! {
                            lm.log(msg: "FilterControlProvider_Identifier :: blocked url \(url)", logType: .debug)
                        }
                        completionHandler(.drop(withUpdateRules: false))
                        return
                    }
                }
            }
            if (self.blockdata?.settings.log_allowed)! {
                lm.log(msg: "FilterControlProvider_Identifier :: allowed url \(url)", logType: .debug)
            }
        }
        
        completionHandler(.allow(withUpdateRules: false))
    }
    
    // MARK: - private helpers
    private func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            lm.log(msg: convertedString ?? "", identifier: "msg-identifier-xxx -", logType: .debug)

        } catch _ {
            lm.log(msg: "Error", identifier: "msg-identifier-xxx -", logType: .debug)
        }
    }
}
