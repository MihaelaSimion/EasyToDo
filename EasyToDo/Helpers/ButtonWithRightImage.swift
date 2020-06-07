//
//  ButtonWithRightImage.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/12/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import UIKit

class ButtonWithRightImage: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
            if isSelected,
                isHighlighted == false {
                let imageWidth = imageView.frame.width
                let buttonWidth = frame.width
                imageEdgeInsets = UIEdgeInsets(top: 0, left: (buttonWidth - imageWidth - 8), bottom: 0, right: 0)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth + 4, bottom: 0, right: 0)
            } else {
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
            }
        }
    }
}
