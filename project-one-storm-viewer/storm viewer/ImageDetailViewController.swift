//
//  ImageDetailViewController.swift
//  storm viewer
//
//  Created by Gregory Hutchinson on 9/30/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!

    internal var imageFilePath: String = ""

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

//MARK: - Public

//MARK: - Private
    private func config() {
        guard imageFilePath != "" else {
            displayFailedToLoadImageAlert()
            return
        }

        title = imageFilePath

        loadImage()
    }

    private func displayFailedToLoadImageAlert() {
        let alertTitle = NSLocalizedString("Oh No!", comment: "unable to display selected image alert title")
        let alertMessage = NSLocalizedString("unable to display selected picture", comment: "more details about not being able to display selected image")

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okayAction = failedToLoadImageAlertOkayAction()

        alertController.addAction(okayAction)

        present(alertController, animated: true, completion: nil)
    }

    private func failedToLoadImageAlertOkayAction() -> UIAlertAction {
        let actionTitle = NSLocalizedString("okay", comment: "unable to display selected image `okay` action")
        let okayAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            DispatchQueue.main.async { [unowned self] in
                self.dismiss()
            }
        }

        return okayAction
    }

    private func loadImage() {
        imageView.image  = UIImage(named: imageFilePath)
    }

    private func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}
