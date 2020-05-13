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

protocol SortOrFilterDelegate: AnyObject {
    func sortTasks(selectedCriteria: SortingCriteria?)
    func filterTasks(selectedCriteria: FilteringCriteria?)
}

class SortOrFilterViewController: UIViewController {
    weak var sortOrFilterDelegate: SortOrFilterDelegate?
    var isSorting = false
    var isFiltering = false
    var selectedSortingCriteria: SortingCriteria?
    var selectedFilteringCriteria: FilteringCriteria?

    @IBOutlet private weak var firstChoice: ButtonWithRightImage!
    @IBOutlet private weak var secondChoice: ButtonWithRightImage!
    @IBOutlet private weak var thirdChoice: ButtonWithRightImage!
    @IBOutlet private weak var fourthChoice: ButtonWithRightImage!
    @IBOutlet private weak var actionButton: ButtonWithRightImage!
    @IBOutlet private weak var removeFilterButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = isSorting ? "Sort" : "Filter"
        setUpViews()
    }

    func setUpViews() {
        firstChoice.setTitle(isSorting ? SortingCriteria.newest.rawValue : FilteringCriteria.high.rawValue, for: .normal)
        secondChoice.setTitle(isSorting ? SortingCriteria.oldest.rawValue : FilteringCriteria.medium.rawValue, for: .normal)
        thirdChoice.setTitle(isSorting ? SortingCriteria.highest.rawValue : FilteringCriteria.low.rawValue, for: .normal)
        removeFilterButton.isHidden = true
        checkPreviouslySelectedCriteria()
        if isSorting {
            fourthChoice.setTitle(SortingCriteria.lowest.rawValue, for: .normal)
            actionButton.isEnabled = selectedSortingCriteria != nil
        } else {
            fourthChoice.isHidden = true
            actionButton.isEnabled = selectedFilteringCriteria != nil
        }
        for button in [firstChoice, secondChoice, thirdChoice, fourthChoice] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.8235294118, blue: 0, alpha: 1)
        }
        actionButton.setTitle(isSorting ? "Sort" : "Filter", for: .normal)
        actionButton.setTitleColor(.lightGray, for: .disabled)
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
        actionButton.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.8235294118, blue: 0, alpha: 1)
    }

    func checkPreviouslySelectedCriteria() {
        if isSorting,
            let filter = selectedSortingCriteria {
            switch filter {
            case .newest:
                firstChoice.isSelected = true
            case .oldest:
                secondChoice.isSelected = true
            case .highest:
                thirdChoice.isSelected = true
            case .lowest:
                fourthChoice.isSelected = true
            }
        } else if isFiltering,
            let filter = selectedFilteringCriteria {
            removeFilterButton.isHidden = false
            switch filter {
            case .high:
                firstChoice.isSelected = true
            case .medium:
                secondChoice.isSelected = true
            case .low:
                thirdChoice.isSelected = true
            }
        }
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

    func enableActionButton() {
        if actionButton.isEnabled == false {
            actionButton.isEnabled = true
        }
    }

    @IBAction private func firstChoiceTapped(_ sender: Any) {
        selectCriteria(selectedChoice: firstChoice)
        enableActionButton()
        if isSorting {
            selectedSortingCriteria = SortingCriteria.newest
        } else if isFiltering {
            selectedFilteringCriteria = FilteringCriteria.high
        }
    }

    @IBAction private func secondChoiceTapped(_ sender: Any) {
        selectCriteria(selectedChoice: secondChoice)
        enableActionButton()
        if isSorting {
            selectedSortingCriteria = SortingCriteria.oldest
        } else if isFiltering {
            selectedFilteringCriteria = FilteringCriteria.medium
        }
    }

    @IBAction private func thirdChoiceTapped(_ sender: Any) {
        selectCriteria(selectedChoice: thirdChoice)
        enableActionButton()
        if isSorting {
            selectedSortingCriteria = SortingCriteria.highest
        } else if isFiltering {
            selectedFilteringCriteria = FilteringCriteria.low
        }
    }

    @IBAction private func fourthChoiceTapped(_ sender: Any) {
        selectCriteria(selectedChoice: fourthChoice)
        enableActionButton()
        selectedSortingCriteria = SortingCriteria.lowest
    }

    @IBAction private func actionButtonTapped(_ sender: Any) {
        if isSorting {
            sortOrFilterDelegate?.sortTasks(selectedCriteria: selectedSortingCriteria)
            navigationController?.popViewController(animated: true)
        } else if isFiltering {
            sortOrFilterDelegate?.filterTasks(selectedCriteria: selectedFilteringCriteria)
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction private func removeFilterButtonTapped(_ sender: Any) {
        sortOrFilterDelegate?.filterTasks(selectedCriteria: nil)
        navigationController?.popViewController(animated: true)
    }
}
