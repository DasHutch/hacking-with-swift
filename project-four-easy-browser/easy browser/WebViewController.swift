//
//  ViewController.swift
//  easy browser
//
//  Created by Gregory Hutchinson on 10/1/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    fileprivate var websites = ["apple.com", "hackingwithswift.com"]

//MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        configWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()

        let url = URL(string: websites[0])!
        load(url: url)
    }

    deinit {
        removeObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            updateProgress()
        }
    }

//MARK: - Public
    func load(url: URL) {
        webView.load(URLRequest(url: url))
    }

//MARK: - Private
    private func configWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView

        webView.allowsBackForwardNavigationGestures = true
    }

    private func config() {
        configProgressView()
        configURLSelectionButton()
        configToolbar()
        addObservers()
    }

    private func configProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
    }

    private func configURLSelectionButton() {
        let openButtonTitle = NSLocalizedString("Open", comment: "title to open an action sheet to select a website to load")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: openButtonTitle, style: .plain, target: self, action: #selector(openTapped))
    }

    private func configToolbar() {
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }

    private func addObservers() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    private func removeObservers() {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    @objc private func openTapped() {
        displayURLSelectionActionSheetcontroller()
    }

    private func openPage(action: UIAlertAction) {
        guard let urlFromActionTitle = action.title else { return }
        guard let url = URL(string: "https://" + urlFromActionTitle) else { return }

        load(url: url)
    }

//MARK: UI
    private func displayURLSelectionActionSheetcontroller() {
        let alertTitle = NSLocalizedString("Open page...", comment: "open page selection title")
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        for website in websites {
            alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }

        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
    }
}

//MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.range(of: website) != nil {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }
}
