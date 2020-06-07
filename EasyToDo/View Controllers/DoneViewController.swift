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

    func markTaskAsUndone(task: Task) {
        do {
            try realm?.write {
                task.done = false
                task.doneDate = nil
            }
        } catch {
            print("Could not mark as done in Realm")
        }
    }
}

extension DoneViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneTasks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell
        let task = doneTasks?[indexPath.row]
        cell?.task = task
        cell?.handleTaskStatusDelegate = self
        cell?.setUpCell()
        return cell ?? UITableViewCell()
    }
}

extension DoneViewController: HandleTaskStatusDelegate {
    func editTaskDoneStatus(forCell: UITableViewCell) {
        guard let index = tableView.indexPath(for: forCell),
            let task = doneTasks?[index.row] else { return }
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to move this back to your ToDo list?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.markTaskAsUndone(task: task)
            self?.tableView.reloadData()
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
