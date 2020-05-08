//
//  MyListViewController.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/8/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import UIKit

class MyListViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.bottom = 8
        searchBar.tintColor = .black
    }

    @IBAction private func newTaskButtonTapped(_ sender: Any) {
    }

    @IBAction private func sortButtonTapped(_ sender: Any) {
    }

    @IBAction private func filterButtonTapped(_ sender: Any) {
    }
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell
        let mockTask = Task()
        mockTask.content = "My To do"
        mockTask.priority = 3
        cell?.setUpCellWith(task: mockTask)
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
