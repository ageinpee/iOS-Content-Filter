//
//  SettingsUIElementsExtension.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 18.05.20.
//  Copyright © 2020 Henrik Peters. All rights reserved.
//

import Foundation
import UIKit

extension SettingsViewController {
    func initUIElements() {
        let enableFilterView = self.initEnabledSwitchSetting()
        let blockFilterView = self.initBlockSwitchSetting()
        let loggingView = self.initLoggingViewSetting()
        //let seperatorView = self.initSeperatorSetting()
        let creditsView = self.initCreditsSection()
        
        self.view.addSubview(enableFilterView)
        self.view.addSubview(blockFilterView)
        self.view.addSubview(loggingView)
        //self.view.addSubview(seperatorView)
        self.view.addSubview(creditsView)
        
        enableFilterView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: 60, enableInsets: false)
        
        blockFilterView.anchor(top: enableFilterView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: 60, enableInsets: false)
        
        loggingView.anchor(top: blockFilterView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: 120, enableInsets: false)
        
        //seperatorView.anchor(top: loggingView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: 60, enableInsets: false)
        
        creditsView.anchor(top: loggingView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: 60, enableInsets: false)
    }
    
    func initCreditsSection() -> UIView {
        let creditsView = UIView()
        
        let imgIcon = UIImage(named: "info")
        let imgView = UIImageView(image: imgIcon)
        imgView.image = imgView.image?.withRenderingMode(.alwaysTemplate)
        if #available(iOS 13.0, *) {
            imgView.tintColor = .systemGray
        } else {
            imgView.tintColor = .black
        }
        creditsView.addSubview(imgView)
        imgView.anchor(top: nil, left: creditsView.leftAnchor, bottom: creditsView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 25, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        
        let infoLabel : UILabel = {
            let lbl = UILabel()
            lbl.text = "Some of the icons in this app are taken from Icons8 at https://icons8.com/icons"
            lbl.textColor = .gray
            lbl.font = UIFont.systemFont(ofSize: 11)
            lbl.numberOfLines = 2
            lbl.lineBreakMode = .byWordWrapping
            return lbl
        }()
        creditsView.addSubview(infoLabel)
        infoLabel.anchor(top: nil, left: imgView.rightAnchor, bottom: creditsView.bottomAnchor, right: creditsView.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 5, paddingRight: 25, width: 0, height: 0, enableInsets: false)
        
        return creditsView
    }
    
    func initEnabledSwitchSetting() -> UIView {
        let switchView = UIView()
        let switchLabel : UILabel = {
            let lbl = UILabel()
            lbl.text = "Enable Content-Filter: "
            return lbl
        }()
        let switchSublabel : UILabel = {
            let lbl = UILabel()
            lbl.text = "If disabled, the Content-Filter is not running. No Data is being tracked."
            lbl.textColor =  .gray
            lbl.font = UIFont.systemFont(ofSize: 10)
            lbl.textAlignment = .left
            lbl.numberOfLines = 2
            lbl.lineBreakMode = .byWordWrapping
            return lbl
        }()
        switchView.addSubview(switchLabel)
        switchLabel.anchor(top: switchView.topAnchor, left: switchView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 25, paddingBottom: 5, paddingRight: 25, width: 0, height: 0, enableInsets: false)
        switchView.addSubview(switchSublabel)
        switchSublabel.anchor(top: switchLabel.bottomAnchor, left: switchView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 5, paddingRight: 25, width: 200, height: 0, enableInsets: false)
        switchView.addSubview(self.loggingSwitch)
        self.loggingSwitch.anchor(top: switchView.topAnchor, left: nil, bottom: nil, right: switchView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 25, width: 0, height: 0, enableInsets: false)
        return switchView
    }
    
    func initBlockSwitchSetting() -> UIView {
        let switchView = UIView()
        let switchLabel : UILabel = {
            let lbl = UILabel()
            lbl.text = "Enable blocking: "
            return lbl
        }()
        let switchSublabel : UILabel = {
            let lbl = UILabel()
            lbl.text = "If disabled, nothing is blocked, but traffic is still tracked. "
            lbl.textColor =  .gray
            lbl.font = UIFont.systemFont(ofSize: 10)
            lbl.textAlignment = .left
            lbl.numberOfLines = 2
            lbl.lineBreakMode = .byWordWrapping
            return lbl
        }()
        switchView.addSubview(switchLabel)
        switchLabel.anchor(top: switchView.topAnchor, left: switchView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 25, paddingBottom: 5, paddingRight: 25, width: 0, height: 0, enableInsets: false)
        switchView.addSubview(switchSublabel)
        switchSublabel.anchor(top: switchLabel.bottomAnchor, left: switchView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 5, paddingRight: 25, width: 200, height: 0, enableInsets: false)
        switchView.addSubview(self.blockSwitch)
        self.blockSwitch.anchor(top: switchView.topAnchor, left: nil, bottom: nil, right: switchView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 25, width: 0, height: 0, enableInsets: false)
        return switchView
    }
    
    func initLoggingViewSetting() -> UIView {
        let loggingView = UIView()
        let loggingLabel : UILabel = {
            let lbl = UILabel()
            lbl.text = "Logging: "
            return lbl
        }()
        let loggingSubLabel : UILabel = {
            let lbl = UILabel()
            lbl.text = "Defines what should be logged"
            lbl.textColor = .gray
            lbl.font = UIFont.systemFont(ofSize: 10)
            lbl.textAlignment = .left
            lbl.numberOfLines = 2
            lbl.lineBreakMode = .byWordWrapping
            return lbl
        }()
        loggingView.addSubview(loggingLabel)
        loggingLabel.anchor(top: loggingView.topAnchor, left: loggingView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 25, paddingBottom: 5, paddingRight: 25, width: 0, height: 0, enableInsets: false)
        loggingView.addSubview(loggingSubLabel)
        loggingSubLabel.anchor(top: loggingLabel.bottomAnchor, left: loggingView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 5, paddingRight: 25, width: 200, height: 0, enableInsets: false)
        loggingView.addSubview(self.loggingSC)
        self.loggingSC.anchor(top: loggingSubLabel.bottomAnchor, left: loggingView.leftAnchor, bottom: nil, right: loggingView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 25, width: 0, height: 0, enableInsets: false)
        return loggingView
    }
    
    func initSeperatorSetting() -> UIView {
        let seperatorView = UIView()
        let seperatorLabel : UILabel = {
            let lbl = UILabel()
            lbl.text = "Trigger a seperator-log: "
            return lbl
        }()
        seperatorView.addSubview(seperatorLabel)
        seperatorLabel.anchor(top: seperatorView.topAnchor, left: seperatorView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 25, paddingBottom: 15, paddingRight: 25, width: 0, height: 0, enableInsets: false)
        seperatorView.addSubview(self.addSeperatorButton)
        self.addSeperatorButton.anchor(top: seperatorView.topAnchor, left: nil, bottom: nil, right: seperatorView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 25, width: 100, height: 30, enableInsets: false)
        return seperatorView
    }
}
