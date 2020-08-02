//
//  SecondViewController.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 31.12.19.
//  Copyright © 2019 Henrik Peters. All rights reserved.
//

import UIKit
import Foundation

// MARK: - RuleViewController
class BlocklistViewController: UITableViewController, UITextFieldDelegate, BlocklistedUrlCellDelegate {
    let cellId = "BlocklistedUrlCell"
    let cdm = try! CoreDataManager()
    var dataSource: [String]? = nil
    var blockdata: ForbiddenData? { didSet{self.dataSource = self.blockdata?.blocklist} }
    var inputTextField: UITextField = UITextField()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blockdata = SharedFileManager.loadBlockdata()
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarUIView?.backgroundColor = .systemBackground
        } else {
            UIApplication.shared.statusBarUIView?.backgroundColor = .white
        }
        
        self.tableView.register(BlocklistedUrlCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - tableView row-routines
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! BlocklistedUrlCell
        let currentLastItem = dataSource![indexPath.row]
        cell.url = currentLastItem
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
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
        label.text = "Blocked URLs"
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

        let input = UITextField()
        input.frame = CGRect.init(x: 5, y: 5, width: footerView.frame.width-10, height: footerView.frame.height-10)
        input.text = ""
        input.textAlignment = .left
        input.placeholder = "Enter url here..."
        input.font = UIFont.systemFont(ofSize: 15)
        input.autocorrectionType = UITextAutocorrectionType.no
        input.keyboardType = UIKeyboardType.default
        input.returnKeyType = UIReturnKeyType.done
        input.clearButtonMode = UITextField.ViewMode.whileEditing
        input.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        input.delegate = self
        self.inputTextField = input
        
        footerView.addSubview(input)
        input.anchor(top: footerView.topAnchor, left: footerView.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 5, paddingRight: 5, width: 250, height: 0, enableInsets: false)
        
        let addButton = UIButton()
        addButton.setTitle("Add URL", for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.gray.cgColor
        addButton.setTitleColor(.gray, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addButton.titleLabel?.textColor = .gray
        addButton.addTarget(self, action: #selector(onAddUrl), for: .touchUpInside)
        
        footerView.addSubview(addButton)
        addButton.anchor(top: footerView.topAnchor, left: nil, bottom: nil, right: footerView.rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 75, height: 0, enableInsets: false)

        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    // MARK: - textField return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: - methods
    @objc func didTapDelete(url: String?) {
        self.showWarning(title: "Deletion", body: "Do you really want to delete the entry '\(url!)'?", then: {
            print("deletion confirmed")
            self.blockdata?.blocklist = self.blockdata?.blocklist.filter { $0 != url! } as! [String]
            SharedFileManager.saveBlockdata(data: self.blockdata!, then: {
                self.blockdata = SharedFileManager.loadBlockdata()
                self.tableView.reloadData()
                return
            })
        }, cancel: {
            print("deletion canceled")
        })
    }
    
    @objc func onAddUrl(_ sender: UIButton, _ input: UITextField) {
        print("button works, input: \(self.inputTextField.text!)")
        // check if input is not empty
        if self.inputTextField.text! == "" {
            return;
        } else {
            self.blockdata?.blocklist.append(self.inputTextField.text!)
            SharedFileManager.saveBlockdata(data: self.blockdata!, then: {
                self.blockdata = SharedFileManager.loadBlockdata()
                self.tableView.reloadData()
                return
            })
            self.inputTextField.text = ""
        }
    }
    
    // MARK: - private methods
//    private func saveNewBlocklist(data: forbiddenData) {
//        if let encodedData = try? JSONEncoder().encode(data) {
//        let dir = SharedFileManager.sharedContainerURL()
//            let fileURL = dir.appendingPathComponent("blockdata.json")
//            do {
//                try encodedData.write(to: fileURL)
//                self.reloadBlockdata()
//                self.tableView.reloadData()
//                print("write data complete")
//            }
//            catch {
//                print("writing failed")
//            }
//        }
//    }
    
//    private func reloadBlockdata() {
//        let dir = SharedFileManager.sharedContainerURL()
//        let sharedURL = dir.appendingPathComponent("blockdata.json")
//        //reading
//        do {
//            let data = try Data(contentsOf: sharedURL)
//            _ = try! JSONSerialization.jsonObject(with: data, options: []) as AnyObject
//            self.blockdata = try! JSONDecoder().decode(forbiddenData.self, from: data)
//            self.dataSource = self.blockdata?.blocklist
//        } catch {
//            let bundleURL = Bundle.main.url(forResource: "blockdata", withExtension: "json")!
//            let bundleData = try! Data(contentsOf: bundleURL)
//            try! bundleData.write(to: sharedURL)
//            _ = try! JSONSerialization.jsonObject(with: bundleData, options: []) as AnyObject
//            self.blockdata = try! JSONDecoder().decode(forbiddenData.self, from: bundleData)
//            self.dataSource = self.blockdata?.blocklist
//        }
//    }
}
