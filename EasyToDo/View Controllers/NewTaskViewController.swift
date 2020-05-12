//
//  NewTaskViewController.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/9/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import RealmSwift
import UIKit

class NewTaskViewController: TapRecognizerViewController {
    var realm: Realm?
    var taskToEdit: Task?
    let alert = Alert()
    var chosenPriority = 3

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var taskContentTextField: UITextField!
    @IBOutlet private weak var highPriorityButton: ButtonWithRightImage!
    @IBOutlet private weak var mediumPriorityButton: ButtonWithRightImage!
    @IBOutlet private weak var lowPriorityButton: ButtonWithRightImage!
    @IBOutlet private weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        getRealmReference()
        addObservers()
        setUpViews()
        setUpInitialPriority()
    }

    func getRealmReference() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setUpViews() {
        for button in [highPriorityButton, mediumPriorityButton, lowPriorityButton] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.8235294118, blue: 0, alpha: 1).cgColor
        }
        addButton.layer.cornerRadius = addButton.frame.size.height / 2
        addButton.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.8235294118, blue: 0, alpha: 1)
        // Task editing
        if let task = taskToEdit {
            taskContentTextField.text = task.content
            addButton.setTitle("Save", for: .normal)
        }
    }

    func setUpInitialPriority() {
        guard let task = taskToEdit else {
            highPriorityButton.isSelected = true
            return }
        switch task.priority {
        case 3:
            highPriorityButton.isSelected = true
            chosenPriority = 3
        case 2:
            mediumPriorityButton.isSelected = true
            chosenPriority = 2
        case 1:
            lowPriorityButton.isSelected = true
            chosenPriority = 1
        default:
            highPriorityButton.isSelected = true
            chosenPriority = 3
        }
    }

    @IBAction private func highPriorityButtonTapped(_ sender: Any) {
        highPriorityButton.isSelected = true
        mediumPriorityButton.isSelected = false
        lowPriorityButton.isSelected = false
        chosenPriority = 3
    }
    @IBAction private func mediumPriorityButtonTapped(_ sender: Any) {
        mediumPriorityButton.isSelected = true
        highPriorityButton.isSelected = false
        lowPriorityButton.isSelected = false
        chosenPriority = 2
    }

    @IBAction private func lowPriorityButtonTapped(_ sender: Any) {
        lowPriorityButton.isSelected = true
        mediumPriorityButton.isSelected = false
        highPriorityButton.isSelected = false
        chosenPriority = 1
    }

    @IBAction private func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func addButtonTapped(_ sender: Any) {
        guard let taskContent = taskContentTextField.text,
            taskContent.isEmpty == false else {
                alert.showAlertForError(title: nil, "Please enter the content of your task.", viewController: self)
                return
        }
        saveOrUpdateTaskToRealm(taskContent: taskContent)
        dismiss(animated: true, completion: nil)
    }

    func saveOrUpdateTaskToRealm(taskContent: String) {
        if let task = taskToEdit {
            updateTask(task: task)
        } else {
            createTask(taskContent: taskContent)
        }
    }

    func createTask(taskContent: String) {
        let task = Task()
        task.content = taskContent
        task.priority = chosenPriority
        do {
            try realm?.write {
                realm?.add(task)
            }
        } catch {
            print("Could not write to Realm")
        }
    }

    func updateTask(task: Task) {
        do {
            try realm?.write {
                if task.content != taskContentTextField.text {
                    task.content = taskContentTextField.text
                }
                if task.priority != chosenPriority {
                    task.priority = chosenPriority
                }
            }
        } catch {
            print("Could not write to Realm")
        }
    }

    // MARK: - Keyboard
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let bottomPadding: CGFloat = 16
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            scrollView.contentInset.bottom = keyboardHeight + bottomPadding
        }
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}
