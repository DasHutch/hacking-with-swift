//
//  Storyboards.swift
//  storm viewer
//
//  Created by Gregory Hutchinson on 9/30/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case LaunchScreen
        case Main
    }

    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
}
