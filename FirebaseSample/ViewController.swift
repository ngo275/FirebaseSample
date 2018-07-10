//
//  ViewController.swift
//  FirebaseSample
//
//  Created by ShuichiNagao on 2018/07/09.
//  Copyright © 2018 Shuichi Nagao. All rights reserved.
//

import UIKit
import UserNotifications
import Pring

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var user: User?
    private var dataSource: DataSource<Book>?
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
            print("push permission finished")
        }
        
        setButton()
        setTableView()
        
        User.anonymousLogin() { [weak self] user in
            self?.user = user
            if let user = user {
                user.fcmToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")
                user.update()
                
                let options = Options()
                let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
                options.sortDescirptors = [sortDescriptor]

                self?.dataSource = user.books.order(by: \Book.createdAt).dataSource(options: options)
                    .on() { (snapshot, changes) in
                        guard let tableView = self?.tableView else { return }
                        switch changes {
                        case .initial:
                            tableView.reloadData()
                        case .update(let deletions, let insertions, let modifications):
                            tableView.beginUpdates()
                            tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                            tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                            tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                            tableView.endUpdates()
                        case .error(let error):
                            print(error)
                        }
                    }.listen()
            }
        }
    }
    
    private func setButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height / 6))
        button.backgroundColor = .black
        button.setTitle("Add Book", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addBook), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func addBook(_ sender: UIButton){
        let book = Book()
        book.name = "Alice in Wonderland"
        user?.books.insert(book)
        user?.update()
    }
    
    private func setTableView() {
        let f = view.frame
        tableView = UITableView(frame: CGRect(x: 0, y: 50 + f.height / 6, width: f.width, height: f.height * 5 / 6 - 50), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        cell.textLabel?.text = dataSource?[indexPath.item].name
        return cell
    }
}
