//
//  InterceptedViewController.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 31.12.19.
//  Copyright © 2019 Henrik Peters. All rights reserved.
//

import UIKit
import Foundation

// MARK: - RuleViewController
class InterceptedViewController: UITableViewController, UITextFieldDelegate, InterceptedUrlCellDelegate {
    let cellId = "BlocklistedUrlCell"
    let cdm = try! CoreDataManager()
    var dataSource: [InterceptedUrlView]? = []
    var interceptedData: InterceptedData? {
        didSet{
            self.dataSource = []
            for interceptedUrl in self.interceptedData!.urllist {
                if let index = self.dataSource!.firstIndex(where: { $0.url == interceptedUrl.url}) {
                    self.dataSource![index].count += 1
                } else {
                    self.dataSource!.append(InterceptedUrlView(url: interceptedUrl.url, count: interceptedUrl.count, isTracker: interceptedUrl.isTracker))
                }
            }
        }
    }
    var inputTextField: UITextField = UITextField()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interceptedData = SharedFileManager.loadIntercepted()
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarUIView?.backgroundColor = .systemBackground
        } else {
            UIApplication.shared.statusBarUIView?.backgroundColor = .white
        }
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.tableView.register(InterceptedUrlCell.self, forCellReuseIdentifier: self.cellId)
        self.refreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                         #selector(self.handleRefresh(_:)),
                                     for: UIControl.Event.valueChanged)
            return refreshControl
        }() as UIRefreshControl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - textField return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: - methods
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.interceptedData = SharedFileManager.loadIntercepted()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func onExportFile() {
        let fileName = "intercepted.json"
        let documentsDirectoryURL = try!
            FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let file2ShareURL = documentsDirectoryURL.appendingPathComponent(fileName)
        let encodedData = try! JSONEncoder().encode(self.interceptedData)
        do {
            try encodedData.write(to: file2ShareURL)
        } catch {
            print(error)
            self.showWarning(title: "Failed", body: "export failed")
        }
        do {
            let _ = try Data(contentsOf: file2ShareURL)
            let activityViewController = UIActivityViewController(activityItems: [file2ShareURL], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        } catch {
            self.showWarning(title: "Failed", body: "export failed")
        }
    }
    
    @objc func onDeleteFile() {
        self.showWarning(title: "Delete Intercepted", body: "Do you really want to delete all urls?", then: {
            SharedFileManager.writeIntercepted(data: InterceptedData(), then: {
                self.interceptedData = SharedFileManager.loadIntercepted()
                self.tableView.reloadData()
                return
            })
            return
        })
    }
    
    @objc private func willEnterForeground() {
        self.interceptedData = SharedFileManager.loadIntercepted()
        self.tableView.reloadData()
    }
}

struct InterceptedUrlView {
    var url = ""
    var count = 0
    var isTracker = false
}
