//
//  ViewController.swift
//  word scramble
//
//  Created by Gregory Hutchinson on 10/2/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import UIKit

class GameViewController: UITableViewController {
    fileprivate lazy var gamePlayManager: GamePlayManager = GamePlayManager()

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        gamePlayManager.startGame()
        updateTitle(text: gamePlayManager.currentWord())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        gamePlayManager.resetGame()
        updateTitle(text: nil)
    }

//MARK: - Public

//MARK: - Private
    private func config() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    }

//MARK: UI
    private func updateTitle(text: String?) {
        title = text
    }

    private func reload() {
        tableView.reloadData()
    }

//MARK: GamePlay
    @objc private func promptForAnswer() {
        displayPromptForAnswerAlert()
    }

    private func submit(answer: String) {
        let result = gamePlayManager.submit(answer: answer)
        switch result {
        case .Success(let correctAnswer):
            handleCorrectAnswer(correctAnswer)
        case .Failure(let error):
            handleWrongAnswer(answer, error: error)
        }
    }

    private func displayPromptForAnswerAlert() {
        let alertTitle = NSLocalizedString("Enter answer", comment: "")
        let ac = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitActiontitle = NSLocalizedString("Submit", comment: "")
        let submitAction = UIAlertAction(title: submitActiontitle, style: .default) { [unowned self, ac] (action: UIAlertAction!) in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }

    private func submitAction(alertController: UIAlertController) -> UIAlertAction {
        let submitActiontitle = NSLocalizedString("Submit", comment: "")
        return UIAlertAction(title: submitActiontitle, style: .default) { [unowned self, alertController] (action: UIAlertAction!) in
            self.submitActionHandler(action: action, controller: alertController)
        }
    }

    private func submitActionHandler(action: UIAlertAction, controller: UIAlertController) {
        guard let answer = controller.textFields?[0], answer.text != nil else {
            print("Something went wrong! Unable to submit answer")
            return
        }

        self.submit(answer: answer.text!)
    }

    /// Animates a new row for our list, as the correct answer is always inserted at indexPath 0,0
    private func handleCorrectAnswer(_ answer: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    private func handleWrongAnswer(_ answer: String, error: GamePlayError) {
        displayWrongAnswerAlert(error: error)
    }

    private func displayWrongAnswerAlert(error: GamePlayError) {
        let ac = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)

        let okayActionTitle = NSLocalizedString("okay", comment: "submitted wrong answer reason ok button")
        ac.addAction(UIAlertAction(title: okayActionTitle, style: .default))
        present(ac, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension GameViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamePlayManager.usedWordList().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = gamePlayManager.usedWordList()[indexPath.row]
        return cell
    }
}
