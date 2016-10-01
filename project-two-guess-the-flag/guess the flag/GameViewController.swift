//
//  ViewController.swift
//  guess the flag
//
//  Created by Gregory Hutchinson on 9/30/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet var answerButtons: [UIButton]!

    private var gameManager = GamePlayManager()

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        askQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        let isCorrectAnswer = gameManager.answerQuestion(answer: sender.tag)
        displayResultsAlertController(didAnswerCorrectly: isCorrectAnswer)
    }

//MARK: - Public

//MARK: - Private
    private func config() {
        gameManager.resetScore()
    }

//MARK: - UI
    private func updateUIForQuestion(_ question: String) {
        title = question
    }

    private func displayResultsAlertController(didAnswerCorrectly: Bool) {
        let score = gameManager.score

        let correctAnswerTitle = NSLocalizedString("Correct", comment: "title for answering correctly")
        let wrongAnswerTitle = NSLocalizedString("Wrong", comment: "title for answering wrongly")

        let answerTitle = didAnswerCorrectly ? correctAnswerTitle : wrongAnswerTitle

        let alertTitle = NSLocalizedString(answerTitle, comment: "correct or wrong answer alert title")
        let alertMessage = NSLocalizedString("your score is \(score)", comment: "current user score")

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(continueAction())
        alertController.addAction(quitAction())

        present(alertController, animated: true, completion: nil)
    }

    private func continueAction() -> UIAlertAction {
        let actionTitle = NSLocalizedString("continue", comment: "continue playing action title")
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            DispatchQueue.main.async { [unowned self] in
                self.askQuestion()
            }
        }

        return action
    }

    private func quitAction() -> UIAlertAction {
        let actionTitle = NSLocalizedString("quit", comment: "quit playing action title")
        let action = UIAlertAction(title: actionTitle, style: .destructive) { (action) in
            DispatchQueue.main.async { [unowned self] in
                self.quit()
            }
        }

        return action
    }

//MARK: Gameplay
    private func askQuestion() {
        let (countries, correctAnswer) = gameManager.askQuestion()
        let question = countries[correctAnswer].uppercased()
        updateUIForQuestion(question)

        for (index, button) in answerButtons.enumerated() {
            button.tag = index
            button.setImage(UIImage(named: countries[index]), for: .normal)
        }
    }

    private func quit() {
        gameManager.resetScore()
        askQuestion()
    }
}

