//
//  MyListViewController.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/8/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import RealmSwift
import UIKit

class MyListViewController: UIViewController {
    var realm: Realm?
    var tasksToDo: Results<Task>?
    var indexForTaskSelectedToEdit: Int?

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.bottom = 8
        searchBar.tintColor = .black
        getRealmReference()
        fetchSavedTasks()
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "taskCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "addOrEditTask",
            let taskViewController = segue.destination as? NewTaskViewController else { return }
        if let selectedCellIndex = indexForTaskSelectedToEdit {
            taskViewController.taskToEdit = tasksToDo?[selectedCellIndex]
            indexForTaskSelectedToEdit = nil
        }
    }

    func getRealmReference() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func fetchSavedTasks() {
        tasksToDo = realm?.objects(Task.self)
            .sorted(byKeyPath: "createdDate", ascending: false)
            .filter("done == FALSE")
    }

    @IBAction private func newTaskButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addOrEditTask", sender: self)
    }

    @IBAction private func sortButtonTapped(_ sender: Any) {
    }

    @IBAction private func filterButtonTapped(_ sender: Any) {
    }
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksToDo?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell
        let task = tasksToDo?[indexPath.row]
        cell?.setUpCellWith(task: task)
        cell?.markTaskAsDoneDelegate = self
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForTaskSelectedToEdit = indexPath.row
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "addOrEditTask", sender: self)
        }
    }
}

extension MyListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // filter
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // To do
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // To do
        searchBar.resignFirstResponder()
    }
}

extension MyListViewController: MarkTaskAsDoneDelegate {
    func moveTaskToDone(forCell: UITableViewCell) {
        guard let index = tableView.indexPath(for: forCell),
            let task = tasksToDo?[index.row] else { return }
        do {
            try realm?.write {
                task.done = true
                task.doneDate = Date()
            }
        } catch {
            print("Could not mark as done in Realm")
        }
        tableView.reloadData()
    }
}
