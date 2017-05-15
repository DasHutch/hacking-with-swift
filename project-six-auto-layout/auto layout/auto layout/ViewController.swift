//
//  ViewController.swift
//  auto layout
//
//  Created by Gregory Hutchinson on 10/9/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

//MARK: - Public

//MARK: - Private
    private func config() {
        setupLabels()
    }

    private func setupLabels() {
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"

        let labels = [label1, label2, label3, label4, label5]
        addLabelsAsSubviews(labels)
        addConstraintsForLabels(labels)
    }

    private func addLabelsAsSubviews(_ labels: [UILabel]) {
        for label in labels {
            view.addSubview(label)
        }
    }

    private func addConstraintsForLabels(_ labels: [UILabel]) {
        var previous: UILabel!
        var viewsDictionary = [String: UILabel]()
        
        for (index, label) in labels.enumerated() {
            // Generate ViewDictionary for use in VFL constraint
            viewsDictionary["label\(index + 1)"] = label

            // Add Constraints for label width and height
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true

            if previous != nil {
                // We have a previous label – create a height constraint
                label.topAnchor.constraint(equalTo: previous.bottomAnchor).isActive = true
            }

            // Set the previous label to be the current one, for the next loop iteration
            previous = label

        }

        let metrics = ["labelHeight": 88]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: [], metrics: metrics, views: viewsDictionary))
    }
}

