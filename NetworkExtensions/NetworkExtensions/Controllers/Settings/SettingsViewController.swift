//
//  FirstViewController.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 31.12.19.
//  Copyright © 2019 Henrik Peters. All rights reserved.
//

import UIKit
import NetworkExtension

class SettingsViewController: UIViewController {
    
    // MARK: - Fieldvariables
    let df: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd'T'H:m:ss.SSS ZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
    var blockdata: ForbiddenData? {
        didSet{
            self.blockSwitch.isOn = self.blockdata?.settings.shall_block ?? false
        }
    }
    
    // MARK: - UIElements
    let loggingSwitch : UISwitch = {
        let swt = UISwitch()
        swt.addTarget(self, action: #selector(onEnabledSwitchValueChanged), for: .valueChanged)
        return swt
    }()
    
    let blockSwitch : UISwitch = {
        let swt = UISwitch()
        swt.addTarget(self, action: #selector(onBlockSwitchValueChanged), for: .valueChanged)
        return swt
    }()
    
    let addSeperatorButton : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onAddSeperator), for: .touchUpInside)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 10
        btn.setTitleColor(.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.titleLabel?.textColor = .gray
        btn.setTitle("Add Seperator", for: .normal)
        return btn
    }()
    
    let loggingSC : UISegmentedControl = {
        let loggingOptions = ["Off", "Capture", "Debug"]
        let sc = UISegmentedControl(items: loggingOptions)
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(onChangeLogging), for: .valueChanged)
        return sc
    }()

    // MARK: - overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.blockdata = SharedFileManager.loadBlockdata()
        self.loggingSC.selectedSegmentIndex = {
            if !self.blockdata!.settings.log_capture && !self.blockdata!.settings.log_debug {
                return 0
            } else if self.blockdata!.settings.log_capture && !self.blockdata!.settings.log_debug {
                return 1
            } else if self.blockdata!.settings.log_capture && self.blockdata!.settings.log_debug {
                return 2
            } else { return 0 }
        }()
        self.initUIElements()
        self.loadFilterPreferences()
    }

    // MARK: - Methods
    @objc func onEnabledSwitchValueChanged(sender: UISwitch!) {
        if (sender!.isOn) {
            enableFilter()
        } else {
            disableFilter()
        }
    }
    
    @objc func onBlockSwitchValueChanged(sender: UISwitch!) {
        if (sender!.isOn) {
            self.blockdata!.settings.shall_block = true
            SharedFileManager.saveBlockdata(data: self.blockdata!)
        } else {
            self.blockdata!.settings.shall_block = false
            SharedFileManager.saveBlockdata(data: self.blockdata!)
        }
    }
    
    @objc func onAddSeperator(sender: UIButton!) {
        let dataString = "{\"seperator\": true, \"log_id\": \"\(UUID().uuidString)\", \"timestamp\":\"\(self.df.string(from: Date()))\"}"
        NSLog("msg-identifer-xxx - \(dataString)")
    }
    
    @objc func onChangeLogging(sender: UISegmentedControl!) {
        print("valuechanged works \(sender.selectedSegmentIndex)")
        switch sender.selectedSegmentIndex {
        case 0:
            self.blockdata!.settings.log_capture = false
            self.blockdata!.settings.log_debug = false
        case 1:
            self.blockdata!.settings.log_capture = true
            self.blockdata!.settings.log_debug = false
        case 2:
            self.blockdata!.settings.log_capture = true
            self.blockdata!.settings.log_debug = true
        default:
            self.blockdata!.settings.log_capture = false
            self.blockdata!.settings.log_debug = false
        }
        SharedFileManager.saveBlockdata(data: self.blockdata!)
    }
    
    // MARK: - private methods
    private func loadFilterPreferences() {
        NEFilterManager.shared().loadFromPreferences { error in
            if let _ = error {
                self.loggingSwitch.isOn = false
                NSLog("LogViewController :: Failed to load preferences")
                return
            }
            
            DispatchQueue.main.async {
                self.loggingSwitch.isOn = NEFilterManager.shared().isEnabled
            }
        }
    }
    
    private func enableFilter() {
        NSLog("LogViewController :: Filter On")
        if NEFilterManager.shared().providerConfiguration == nil {
            let newConfiguration = NEFilterProviderConfiguration()
            newConfiguration.username = "Network Filter"
            newConfiguration.organization = "Network Filter App"
            newConfiguration.filterBrowsers = true
            newConfiguration.filterSockets = true
            NEFilterManager.shared().providerConfiguration = newConfiguration
            
            /*if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
                NEFilterManager.shared().localizedDescription = appName
            }*/
        }
        NEFilterManager.shared().isEnabled = true
        NEFilterManager.shared().saveToPreferences { error in
            if let err = error {
                self.showWarning(title: "Error Enabling Filter", body: "\(err)")
            }
        }
        
        DispatchQueue.main.async {
            self.loggingSwitch.isOn = true
        }
    }
    
    private func disableFilter() {
        NSLog("LogViewController :: Filter Off")
        NEFilterManager.shared().isEnabled = false
        NEFilterManager.shared().saveToPreferences { error in
            if let err = error {
                self.showWarning(title: "Error Disabling Filter", body: "\(err)")
            }
        }
    }
    
    private func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print("msg-identifer-xxx - \(convertedString!)") // <-- here is ur string

        } catch _ {
            print("msg-identifer-xxx - Error")
        }

    }
}

