//
//  BlacklistedUrlCell.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 18.05.20.
//  Copyright © 2020 Henrik Peters. All rights reserved.
//

import Foundation
import UIKit

// MARK: - BlacklistedUrloverride Cell
protocol BlocklistedUrlCellDelegate {
    func didTapDelete(url: String?)
}


// MARK: - BlacklistedUrloverride Cell
class BlocklistedUrlCell: UITableViewCell {
    var delegate: BlocklistedUrlCellDelegate? = nil
    var url : String {
        didSet {
            self.urlLabel.text = self.url
        }
    }
    
    private let urlLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor =  .gray
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private let delButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Navigation_Trash_2x"), for: .normal)
        return btn
    }()
    
    //  MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        url = ""
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.urlLabel)
        self.addSubview(self.delButton)
        self.delButton.addTarget(self, action: #selector(onDeleteUrl), for: .touchUpInside)
        
        self.urlLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 5, width: 280, height: 0, enableInsets: false)
        self.delButton.anchor(top: self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 15, width: 50, height: 0, enableInsets: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc func onDeleteUrl(_ sender: UIButton) {
        self.delegate?.didTapDelete(url: self.urlLabel.text)
    }
}
