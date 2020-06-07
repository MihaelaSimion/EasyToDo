//
//  TaskTableViewCell.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/8/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import UIKit

protocol HandleTaskStatusDelegate: AnyObject {
    func editTaskDoneStatus(forCell: UITableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    var task: Task?
    weak var handleTaskStatusDelegate: HandleTaskStatusDelegate?

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var taskContentLabel: UILabel!
    @IBOutlet private weak var taskDoneButton: UIButton!
    @IBOutlet private weak var dateExplanationLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var priorityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setUpCell() {
        setUpViews()
        taskContentLabel.text = task?.content
        if task?.done == true {
            containerView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
            taskDoneButton.backgroundColor = #colorLiteral(red: 0.5607843137, green: 0.7882352941, blue: 0.7333333333, alpha: 1)
            dateExplanationLabel.text = "Done on:"
            dateLabel.text = task?.doneDate?.dateToString()
        } else {
            containerView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.8235294118, blue: 0, alpha: 1)
            taskDoneButton.backgroundColor = .white
            taskDoneButton.layer.borderWidth = 1
            taskDoneButton.layer.borderColor = UIColor.lightGray.cgColor
            dateExplanationLabel.text = "Created on:"
            dateLabel.text = task?.createdDate.dateToString()
        }
        if let priorityValue = task?.priority,
            let priority = Priority(rawValue: priorityValue) {
            priorityLabel.text = "\(priority)"
        }
    }

    func setUpViews() {
        containerView.layer.cornerRadius = 8
        taskDoneButton.layer.cornerRadius = taskDoneButton.frame.size.height / 2
    }

    @IBAction private func taskDoneButtonTapped(_ sender: Any) {
        handleTaskStatusDelegate?.editTaskDoneStatus(forCell: self)
    }
}
