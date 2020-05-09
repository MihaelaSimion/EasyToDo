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

    func fetchSavedTasks() {
        tasksToDo = realm?.objects(Task.self)
            .sorted(byKeyPath: "createdDate", ascending: false)
    }

    @IBAction private func newTaskButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addNewTask", sender: self)
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
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // to do - open task screen to edit
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
