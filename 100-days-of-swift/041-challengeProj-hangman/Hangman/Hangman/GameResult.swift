//
//  GameResult.swift
//  Wordle
//
//  Created by Daniel Sasse on 1/13/22.
//

import Foundation

struct GameResult: Codable {
    var word: String
    var score: Int
    var date: String
}
