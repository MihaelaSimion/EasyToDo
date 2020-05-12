//
//  SortOrFilterViewController.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/12/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import UIKit

enum SortingCriteria: String {
    case newest = "Newest"
    case oldest = "Oldest"
    case highest = "Highest priority"
    case lowest = "Lowest priority"
}

enum FilteringCriteria: String {
    case high = "High priority"
    case medium = "Medium priority"
    case low = "Low priority"
}

class SortOrFilterViewController: UIViewController {
    var isSorting = false
    var isFiltering = false

    @IBOutlet private weak var firstChoice: ButtonWithRightImage!
    @IBOutlet private weak var secondChoice: ButtonWithRightImage!
    @IBOutlet private weak var thirdChoice: ButtonWithRightImage!
    @IBOutlet private weak var fourthChoice: ButtonWithRightImage!
    @IBOutlet private weak var actionButton: ButtonWithRightImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = isSorting ? "Sort" : "Filter"
        setUpViews()
    }

    func setUpViews() {
        firstChoice.setTitle(isSorting ? SortingCriteria.newest.rawValue : FilteringCriteria.high.rawValue, for: .normal)
        secondChoice.setTitle(isSorting ? SortingCriteria.oldest.rawValue : FilteringCriteria.medium.rawValue, for: .normal)
        thirdChoice.setTitle(isSorting ? SortingCriteria.highest.rawValue : FilteringCriteria.low.rawValue, for: .normal)
        if isSorting {
            fourthChoice.setTitle(SortingCriteria.lowest.rawValue, for: .normal)
        } else {
            fourthChoice.isHidden = true
        }
        for button in [firstChoice, secondChoice, thirdChoice, fourthChoice] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.8235294118, blue: 0, alpha: 1)
        }
        actionButton.setTitle(isSorting ? "Sort" : "Filter", for: .normal)
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
        actionButton.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.8235294118, blue: 0, alpha: 1)
    }

    @IBAction private func firstChoiceTapped(_ sender: Any) {
        selectCriteria(selectedChoice: firstChoice)
    }

    @IBAction private func secondChoiceTapped(_ sender: Any) {
        selectCriteria(selectedChoice: secondChoice)
    }

    @IBAction private func thirdChoiceTapped(_ sender: Any) {
        selectCriteria(selectedChoice: thirdChoice)
    }

    @IBAction private func fourthChoiceTapped(_ sender: Any) {
        selectCriteria(selectedChoice: fourthChoice)
    }

    func selectCriteria(selectedChoice: ButtonWithRightImage) {
        guard selectedChoice.isSelected == false else { return }
        selectedChoice.isSelected = true

        var toDeselect: [ButtonWithRightImage] = []
        if selectedChoice != firstChoice {
            toDeselect.append(firstChoice)
        }
        if selectedChoice != secondChoice {
            toDeselect.append(secondChoice)
        }
        if selectedChoice != thirdChoice {
            toDeselect.append(thirdChoice)
        }
        if isSorting,
            selectedChoice != fourthChoice {
            toDeselect.append(fourthChoice)
        }
        for choice in toDeselect {
            choice.isSelected = false
        }
    }
}
