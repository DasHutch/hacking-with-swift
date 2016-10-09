//
//  GameManager.swift
//  word scramble
//
//  Created by Gregory Hutchinson on 10/9/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import Foundation
import GameplayKit

struct GamePlayError {
    let title: String
    let message: String
}

enum GamePlayResult<T> {
    case Success(T)
    case Failure(GamePlayError)
}

struct GamePlayManager {
    private var allWords = [String]()
    private var usedWords = [String]()
    private var activeWord: String?

    init() {
        loadWords()
    }

//MARK: - Public
    mutating func submit(answer: String) -> GamePlayResult<String> {
        let lowerAnswer = answer.lowercased()

        let errorTitle: String
        let errorMessage: String

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    return GamePlayResult.Success(answer)
                }else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know!"
                }
            }else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        }else {
            if let word = activeWord {
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from '\(word.lowercased())'!"
            }else {
                errorTitle = "Error"
                errorMessage = "No currernt word, something went very wrong."
            }
        }

        let gamePlayError = GamePlayError(title: errorTitle, message: errorMessage)
        return GamePlayResult.Failure(gamePlayError)
    }

    func wordList() -> [String] {
        return allWords
    }

    func usedWordList() -> [String] {
        return usedWords
    }

    func currentWord() -> String? {
        return activeWord
    }

    mutating func startGame() {
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        activeWord = allWords[0]

        resetGame()
    }

    mutating func resetGame() {
        usedWords.removeAll(keepingCapacity: true)
    }

//MARK: - Private
    private mutating func loadWords() {
        if (allWords.count > 1) {
            return
        }

        let fileName = "start"
        let fileExt = "txt"

        let separator = "\n"

        if let startWordsPath = Bundle.main.path(forResource: fileName, ofType: fileExt) {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: separator)
            }
        }else {
            allWords = ["silkworm"]
        }
    }

//MARK: Validation
    private func isPossible(word: String) -> Bool {
        guard let activeWord = activeWord?.lowercased(), word != "" else {
            return false
        }

        var tempWord = activeWord

        for letter in word.characters {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            }else {
                return false
            }
        }

        return true
    }

    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
}
