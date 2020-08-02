//
//  InterceptedViewControllerExtension.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 21.05.20.
//  Copyright © 2020 Henrik Peters. All rights reserved.
//

import Foundation
import UIKit

extension InterceptedViewController {
    // MARK: - tableView row-routines
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! InterceptedUrlCell
        let currentLastItem = dataSource![indexPath.row]
        cell.interceptedUrl = currentLastItem
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.showWarning(title: "Intercepted URL", body: self.interceptedData?.urllist[indexPath.row].url ?? "")
    }
    
    // MARK: - tableView header-routines
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        if #available(iOS 13.0, *) {
            headerView.backgroundColor = UIColor.systemBackground
        } else {
            headerView.backgroundColor = UIColor.white
        }
        headerView.layer.addBorder(edge: .bottom, color: UIColor.lightGray, thickness: 0.5)

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Intercepted URLs"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center

        headerView.addSubview(label)

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - tableView footer-routines
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        if #available(iOS 13.0, *) {
            footerView.backgroundColor = UIColor.systemBackground
        } else {
            footerView.backgroundColor = UIColor.white
        }
        footerView.layer.addBorder(edge: .top, color: UIColor.lightGray, thickness: 0.5)

        let deleteButton = UIButton()
        deleteButton.setTitle("Clear File", for: .normal)
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor.lightGray.cgColor
        deleteButton.setTitleColor(.gray, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        deleteButton.addTarget(self, action: #selector(onDeleteFile), for: .touchUpInside)
        
        footerView.addSubview(deleteButton)
        deleteButton.anchor(top: footerView.topAnchor, left: footerView.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 5, paddingRight: 15, width: 150, height: 30, enableInsets: false)
        
        let exportButton = UIButton()
        exportButton.setTitle("Export File", for: .normal)
        exportButton.layer.cornerRadius = 10
        exportButton.layer.borderWidth = 1
        exportButton.layer.borderColor = UIColor.lightGray.cgColor
        exportButton.setTitleColor(.gray, for: .normal)
        exportButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        exportButton.addTarget(self, action: #selector(onExportFile), for: .touchUpInside)
        
        footerView.addSubview(exportButton)
        exportButton.anchor(top: footerView.topAnchor, left: nil, bottom: nil, right: footerView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 5, paddingRight: 15, width: 150, height: 30, enableInsets: false)

        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
