//
//  TaskTableViewCell.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/8/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import UIKit

protocol MarkTaskAsDoneDelegate: AnyObject {
    func moveTaskToDone(forCell: UITableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    weak var markTaskAsDoneDelegate: MarkTaskAsDoneDelegate?

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

    func setUpCellWith(task: Task?) {
        setUpViews()
        taskContentLabel.text = task?.content
        if task?.done == true {
            taskDoneButton.backgroundColor = #colorLiteral(red: 0.5607843137, green: 0.7882352941, blue: 0.7333333333, alpha: 1)
            taskDoneButton.layer.borderWidth = 0
            dateExplanationLabel.text = "Done on:"
            if let doneDate = task?.doneDate {
                dateLabel.text = doneDate.dateToString()
            }
        } else {
            taskDoneButton.layer.borderWidth = 1
            taskDoneButton.layer.borderColor = UIColor.lightGray.cgColor
            taskDoneButton.backgroundColor = .white
            dateExplanationLabel.text = "Created on:"
            dateLabel.text = task?.createdDate.dateToString()
        }
        if let priorityValue = task?.priority,
            let priority = Priority(rawValue: priorityValue) {
            priorityLabel.text = "\(priority)"
        }
    }

    func setUpViews() {
        containerView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        containerView.layer.cornerRadius = 8
        taskDoneButton.layer.cornerRadius = taskDoneButton.frame.size.height / 2
    }

    @IBAction private func taskDoneButtonTapped(_ sender: Any) {
        markTaskAsDoneDelegate?.moveTaskToDone(forCell: self)
    }
}
