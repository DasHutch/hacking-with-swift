//
//  ViewController.swift
//  storm viewer
//
//  Created by Gregory Hutchinson on 9/30/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import UIKit

class ImagesViewController: UITableViewController {

    fileprivate var datasource = DataSource()
    fileprivate var imageFilePaths = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

//MARK: - Public

//MARK: - Private
    private  func config() {
        title = NSLocalizedString("Storm Viewer", comment: "navigation controller title for list of images scene")

        imageFilePaths = datasource.imageFilePaths()
    }
}

//MARK: - UITableViewDataSource
extension ImagesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.numberOfRowsInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PictureTableViewCell
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PictureTableViewCell else { return }
        cell.configWithImage(filepath: datasource.imageFilePathAt(index: indexPath.row))
    }
}

//MARK: - UITableViewDelegate
extension ImagesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageFilepathToDisplay = datasource.imageFilePathAt(index: indexPath.row)
        displayImageDetail(selectedImageFilepath: imageFilepathToDisplay)
    }

    private func imageDetailViewController() -> ImageDetailViewController {
        let storyboard = UIStoryboard.storyboard(storyboard: .Main)
        let viewController: ImageDetailViewController = storyboard.instantiateViewController()
        return viewController
    }

    private func displayImageDetail(selectedImageFilepath: String) {
        let viewController = imageDetailViewController()
        viewController.imageFilePath = selectedImageFilepath

        navigationController?.pushViewController(viewController, animated: true)
    }
}
