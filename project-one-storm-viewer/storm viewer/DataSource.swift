//
//  DataSource.swift
//  storm viewer
//
//  Created by Gregory Hutchinson on 9/30/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import Foundation

struct DataSource {

    private let fm = FileManager.default
    private let path = Bundle.main.resourcePath!
    private var imagePaths = [String]()

//MARK: - Public
    public mutating func imageFilePaths() -> [String] {
        if imagePaths.count > 0 {
            return imagePaths
        }

        do {
            let paths = try fm.contentsOfDirectory(atPath: path)
            imagePaths = processMainBundleContent(paths: paths)
            return imagePaths
        }catch let error {
            print(error)
            return [String]()
        }
    }

    public func imageFilePathAt(index: Int) -> String {
        if index <= imagePaths.count {
            return imagePaths[index]
        }else {
            // NOTE: Allow for soft fail
            //       this will wind up displaying nothing in cell
            //       which is better than a crash or dealing with optionals
            print("Unable to retrive image fielpath for index: \(index)")
            return ""
        }
    }

    public func numberOfRowsInSection(section: Int = 0) -> Int {
        //NOTE: this currently only has one section, so
        //      we will default to section `0` and frankly just ignore it...
        return imagePaths.count
    }

//MARK: - Private
    private func processMainBundleContent(paths: [String]) -> [String] {
        let imageFilepathPrefix = "nssl"

        return paths.filter { (path) -> Bool in
            return path.hasPrefix(imageFilepathPrefix)
        }
    }
}
