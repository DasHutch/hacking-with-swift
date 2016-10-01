//
//  StoryboardIdentifiable.swift
//  storm viewer
//
//  Created by Gregory Hutchinson on 9/30/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//
// https://medium.com/swift-programming/uistoryboard-safer-with-enums-protocol-extensions-and-generics-7aad3883b44d#.7fb1hquwb

import Foundation
import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
