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
    var tasksToShowInToDoList: Results<Task>?
    var indexForTaskSelectedToEdit: Int?
    var showingSearchResults = false
    var sortButtonTapped = false
    var filterButtonTapped = false
    var selectedSortingCriteria: SortingCriteria?
    var selectedFilteringCriteria: FilteringCriteria?

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
        if segue.identifier == "addOrEditTask",
            let taskViewController = segue.destination as? NewTaskViewController,
            let selectedCellIndex = indexForTaskSelectedToEdit {
            taskViewController.taskToEdit = tasksToShowInToDoList?[selectedCellIndex]
            indexForTaskSelectedToEdit = nil
        } else if segue.identifier == "sortOrFilterTasks",
            let sortOrFilterVC = segue.destination as? SortOrFilterViewController {
            sortOrFilterVC.sortOrFilterDelegate = self
            if sortButtonTapped {
                sortOrFilterVC.isSorting = true
                guard let criteria = selectedSortingCriteria else {
                    sortOrFilterVC.selectedSortingCriteria = SortingCriteria.newest // default sorting
                    return
                }
                sortOrFilterVC.selectedSortingCriteria = criteria
            } else if filterButtonTapped {
                sortOrFilterVC.isFiltering = true
                sortOrFilterVC.selectedFilteringCriteria = selectedFilteringCriteria
            }
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
        tasksToShowInToDoList = tasksToDo
    }

    func deleteTask(task: Task) {
        do {
            try realm?.write {
                realm?.delete(task)
            }
        } catch {
            print("Could not delete object from Realm.")
        }
    }

    func markTaskAsDone(task: Task) {
        do {
            try realm?.write {
                task.done = true
                task.doneDate = Date()
            }
        } catch {
            print("Could not mark as done in Realm")
        }
    }

    func showTasksFromSearch(searchText: String) {
        tasksToShowInToDoList = tasksToDo?.filter("content CONTAINS [c] '\(searchText)'")
        tableView.reloadData()
    }

    func showAllToDoTasks() {
        tasksToShowInToDoList = tasksToDo
        showingSearchResults = false
        tableView.reloadData()
    }

    @IBAction private func newTaskButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addOrEditTask", sender: self)
    }

    @IBAction private func sortButtonTapped(_ sender: Any) {
        sortButtonTapped = true
        filterButtonTapped = false
        performSegue(withIdentifier: "sortOrFilterTasks", sender: self)
    }

    @IBAction private func filterButtonTapped(_ sender: Any) {
        filterButtonTapped = true
        sortButtonTapped = false
        performSegue(withIdentifier: "sortOrFilterTasks", sender: self)
    }
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showingSearchResults,
            tasksToShowInToDoList?.isEmpty == true {
            return 1
        }
        return tasksToShowInToDoList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showingSearchResults,
            tasksToShowInToDoList?.isEmpty == true {
            let noSearchResultCell = tableView.dequeueReusableCell(withIdentifier: "noSearchResultCell", for: indexPath)
            return noSearchResultCell
        }

        let taskCell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell
        let task = tasksToShowInToDoList?[indexPath.row]
        taskCell?.task = task
        taskCell?.setUpCell()
        taskCell?.handleTaskStatusDelegate = self
        return taskCell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tasksToShowInToDoList?.isEmpty == false else { return }
        indexForTaskSelectedToEdit = indexPath.row
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "addOrEditTask", sender: self)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard tasksToShowInToDoList?.isEmpty == false else { return .none }
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let taskToDelete = tasksToShowInToDoList?[indexPath.row] else { return }
        deleteTask(task: taskToDelete)
        tableView.reloadData()
    }
}

extension MyListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        showingSearchResults = true
        showTasksFromSearch(searchText: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showAllToDoTasks()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        showAllToDoTasks()
    }
}

extension MyListViewController: HandleTaskStatusDelegate {
    func editTaskDoneStatus(forCell: UITableViewCell) {
        guard let index = tableView.indexPath(for: forCell),
            let task = tasksToShowInToDoList?[index.row] else { return }
        markTaskAsDone(task: task)
        tableView.reloadData()
    }
}

extension MyListViewController: SortOrFilterDelegate {
    func sortTasks(selectedCriteria: SortingCriteria?) {
        selectedSortingCriteria = selectedCriteria
        switch selectedCriteria {
        case .newest:
            tasksToShowInToDoList = tasksToDo?.sorted(byKeyPath: "createdDate", ascending: false)
        case .oldest:
            tasksToShowInToDoList = tasksToDo?.sorted(byKeyPath: "createdDate", ascending: true)
        case .highest:
            tasksToShowInToDoList = tasksToDo?.sorted(byKeyPath: "priority", ascending: false)
        case .lowest:
            tasksToShowInToDoList = tasksToDo?.sorted(byKeyPath: "priority", ascending: true)
        default:
            break
        }
        tableView.reloadData()
    }

    func filterTasks(selectedCriteria: FilteringCriteria?) {
        selectedFilteringCriteria = selectedCriteria
        if let criteria = selectedCriteria {
            switch criteria {
            case .high:
                tasksToShowInToDoList = tasksToDo?.filter("priority == 3")
            case .medium:
                tasksToShowInToDoList = tasksToDo?.filter("priority == 2")
            case .low:
                tasksToShowInToDoList = tasksToDo?.filter("priority == 1")
            }
            tableView.reloadData()
        } else {
            tasksToShowInToDoList = tasksToDo
            tableView.reloadData()
        }
    }
}
