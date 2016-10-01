//
//  ImageDetailViewController.swift
//  storm viewer
//
//  Created by Gregory Hutchinson on 9/30/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import UIKit
import Social

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        loadImage()
    }

    private func dismiss() {
        navigationController?.popViewController(animated: true)
    }

//MARK: UI
    private func displayFailedToLoadImageAlert() {
        let alertTitle = NSLocalizedString("Oh No!", comment: "unable to display selected image alert title")
        let alertMessage = NSLocalizedString("unable to display selected picture", comment: "more details about not being able to display selected image")

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(failedToLoadImageAlertOkayAction())

        present(alertController, animated: true, completion: nil)
    }

    private func failedToLoadImageAlertOkayAction() -> UIAlertAction {
        let actionTitle = NSLocalizedString("okay", comment: "unable to display selected image `okay` action")
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            DispatchQueue.main.async { [unowned self] in
                self.dismiss()
            }
        }

        return action
    }

    private func loadImage() {
        imageView.image  = UIImage(named: imageFilePath)
    }

    private func displayShareTypeActionSheetController() {
        let alertTitle = NSLocalizedString("Share", comment: "share type selection alert title")

        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(basicShareAction())
        alertController.addAction(facebookShareAction())
        alertController.addAction(twitterShareAction())

        present(alertController, animated: true, completion: nil)
    }

    private func basicShareAction() -> UIAlertAction {
        let actionTitle = NSLocalizedString("ios", comment: "default ios share sheet action title")
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            DispatchQueue.main.async { [unowned self] in
                self.basicShare()
            }
        }

        return action
    }

    private func facebookShareAction() -> UIAlertAction {
        let actionTitle = NSLocalizedString("facebook", comment: "share on facebook action title")
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            DispatchQueue.main.async { [unowned self] in
                self.facebookShare()
            }
        }

        return action
    }

    private func twitterShareAction() -> UIAlertAction {
        let actionTitle = NSLocalizedString("twitter", comment: "share on twitter action title")
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            DispatchQueue.main.async { [unowned self] in
                self.twitterShare()
            }
        }
        
        return action
    }

//MARK: Social
    @objc private func shareTapped() {
        displayShareTypeActionSheetController()
    }

    private func basicShare() {
        guard let image = imageView.image else { return }

        let viewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(viewController, animated: true)
    }

    private func facebookShare() {
        socialShare(service: SLServiceTypeFacebook)
    }

    private func twitterShare() {
        socialShare(service: SLServiceTypeTwitter)
    }

    private func socialShare(service: String) {
        guard let image = imageView.image else { return }
        guard let viewController = SLComposeViewController(forServiceType: service) else { return }

        let shareText = NSLocalizedString("Look at this great picture!", comment: "share text for the image")
        viewController.setInitialText(shareText)
        viewController.add(image)
        viewController.add(URL(string: "http://www.photolib.noaa.gov/nssl"))

        present(viewController, animated: true)
    }
}
