//
//  UIStoryboard+Instantiation.swift
//  storm viewer
//
//  Created by Gregory Hutchinson on 9/30/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//
// https://medium.com/swift-programming/uistoryboard-safer-with-enums-protocol-extensions-and-generics-7aad3883b44d#.7fb1hquwb

import Foundation
import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        let optionalViewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)

        guard let viewController = optionalViewController as? T else {
            fatalError("Couldn’t instantiate view controller with identifier \(T.storyboardIdentifier)")
        }

        return viewController
    }
}
