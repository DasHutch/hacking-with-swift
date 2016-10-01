//
//  GamePlayManager.swift
//  guess the flag
//
//  Created by Gregory Hutchinson on 10/1/16.
//  Copyright © 2016 Das Hutch Development. All rights reserved.
//

import Foundation
import GameplayKit

struct GamePlayManager {
    private var countries = [String]()
    private(set) var score = 0
    private var correctAnswer = 0

//MARK: - Public
    init() {
        configCountries()
    }

    mutating func askQuestion() -> ([String], Int) {
        countries = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: countries) as! [String]
        correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        return (countries, correctAnswer)
    }

    mutating func answerQuestion(answer: Int) -> Bool {
        answer == correctAnswer ? incrementScore() : decrementScore()
        return answer == correctAnswer
    }

    mutating func resetScore() {
        score = 0
    }

//MARK: - Private
    private mutating func configCountries() {
        countries += [
            "estonia",
            "france",
            "germany",
            "ireland",
            "italy",
            "monaco",
            "nigeria",
            "poland",
            "russia",
            "spain",
            "uk",
            "us"
        ]
    }

//MARK: Scoring
    private mutating func incrementScore() {
        score += 1
    }

    private mutating func decrementScore() {
        score -= 1
    }
}
