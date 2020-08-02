//
//  InterceptedUrlCell.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 18.05.20.
//  Copyright © 2020 Henrik Peters. All rights reserved.
//

import Foundation
import UIKit

// MARK: - BlacklistedUrloverride Cell
protocol InterceptedUrlCellDelegate {
}


// MARK: - BlacklistedUrloverride Cell
class InterceptedUrlCell: UITableViewCell {
    var delegate: InterceptedUrlCellDelegate? = nil
    var interceptedUrl : InterceptedUrlView? {
        didSet {
            self.urlLabel.text = self.interceptedUrl?.url ?? ""
            self.countLabel.text = String(self.interceptedUrl?.count ?? 0)
            self.urlLabel.textColor = (interceptedUrl?.isTracker ?? false) ? .red : .gray
        }
    }
    
    private let urlLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor =  .gray
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private let countLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .right
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    
    //  MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.interceptedUrl = nil
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.urlLabel)
        self.urlLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 5, width: 300, height: 0, enableInsets: false)
        self.addSubview(self.countLabel)
        self.countLabel.anchor(top: self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 15, width: 50, height: 0, enableInsets: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
}
