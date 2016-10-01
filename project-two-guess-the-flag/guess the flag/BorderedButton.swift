//
//  BorderedButton.swift
//  guess the flag
//
//  Created by Gregory Hutchinson on 10/1/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import UIKit


@IBDesignable class BorderedButton: UIButton {
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
