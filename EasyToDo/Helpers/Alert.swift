//
//  Alert.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/9/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import UIKit

struct Alert {
    func showAlertForError(title: String?, _ errorDescription: String, viewController: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: errorDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(action)
        viewController.present(alertController, animated: true)
    }
}
