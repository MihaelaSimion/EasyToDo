//
//  DoneViewController.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/8/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import RealmSwift
import UIKit

class DoneViewController: UIViewController {
    var realm: Realm?
    var doneTasks: Results<Task>?
    
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.top = 16
        tableView.contentInset.bottom = 8
        getRealmReference()
        fetchSavedDoneTasks()
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "taskCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func getRealmReference() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func fetchSavedDoneTasks() {
        doneTasks = realm?.objects(Task.self)
            .filter("done == TRUE")
            .sorted(byKeyPath: "doneDate", ascending: false)
    }
}

extension DoneViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneTasks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell
        let task = doneTasks?[indexPath.row]
        cell?.setUpCellWith(task: task)
        return cell ?? UITableViewCell()
    }
}
