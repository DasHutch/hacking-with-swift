//
//  PictureTableViewCell.swift
//  storm viewer
//
//  Created by Gregory Hutchinson on 9/30/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {
//MARK: - Lifecycle

//MARK: - Public
    public func configWithImage(filepath: String) {
        textLabel?.text = filepath
    }

//MARK: - Private
}
