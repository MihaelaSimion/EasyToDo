//
//  TapRecognizerViewController.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/9/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import UIKit

class TapRecognizerViewController: UIViewController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardTap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        dismissKeyboardTap.delegate = self
        dismissKeyboardTap.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTap)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return true }
        return touchView.isKind(of: UIControl.self) == false
    }
}
