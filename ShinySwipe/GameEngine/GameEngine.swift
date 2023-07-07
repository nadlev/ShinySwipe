//
//  GameEngine.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import Foundation
import SwiftUI

class GameEngine: ObservableObject {
    
    static let shared = GameEngine()
    /// The GameEngine class is responsible for managing the state of the game and updating the game board.
    
    enum State {
        // The State enum represents the different states that the game can be in: start, running, won, or over.
        case start
        case won
        case running
        case over
    }

    // The defaults property is used to save the player's progress and leaderboard.
    let defaults = UserDefaults.standard

    @Published var state: State = .running {
        didSet {
            switch state {
            case .over:
                print("game over")
                let record = Record(playerName: playerName, score: score)
                            leaderBoard.append(record)
            case .won:
                let record = Record(playerName: playerName, score: score)
                leaderBoard.append(record)
                defaults.set(highest, forKey: "High Score")
            case .start:
                board = Board(size: boardSize)
                print(boardSize)
                score = 0
                print("started")
                print(board.size)
                state = .running
            case .running:
                print("running")
            }
        }
    }

    var playerName: String {
        didSet {
            defaults.set(playerName, forKey: "Player Name")
        }
    }

    var leaderBoard: [Record] = [Record]() {
        didSet {
            leaderBoard.sort(by: { $0.score > $1.score })
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(leaderBoard) {
                defaults.set(encoded, forKey: "Leaderboard")
            }
        }
    }

    @Published var score: Int = 0 {
        didSet {
            if score > highest {
                highest = score
            }
        }
    }

    @Published var highest: Int = 0

    init() {
        highest = UserDefaults.standard.integer(forKey: "High Score")
        playerName = UserDefaults.standard.string(forKey: "Player Name") ?? "Player 1"

        if let savedLeaderboard = defaults.object(forKey: "Leaderboard") as? Data {
            print("theres memory")
            let decoder = JSONDecoder()
            if let loadedLeaderboard = try? decoder.decode([Record].self, from: savedLeaderboard) {
                print("could decode")
                leaderBoard = loadedLeaderboard
            }
        }
    }

    var boardSize: Int = 3
    @Published var board: Board = Board(size: 3)

    //swiftlint:disable cyclomatic_complexity
    // The dropRandomTile method is responsible for randomly dropping a new tile onto the game board.
    // It takes one parameter, direction, which represents the direction in which the tile should be added.
    fileprivate func dropRandomTile(direction: MoveDirection) {
        if state != .over {
            switch direction {
            case .up:
                if let column = findEmptyTile(array: board.grid[boardSize-1]) {
                    board.grid[boardSize-1][column].value = 2
                }
            case .down:
                if let column = findEmptyTile(array: board.grid[0]) {
                    board.grid[0][column].value = 2
                }
            case .left:
                var lastColumn = [Tile]()
                for line in board.grid {
                    lastColumn.append(line.last!)
                }
                if let chosen = findEmptyTile(array: lastColumn) {
                    board.grid[chosen][boardSize-1].value = 2
                }
            case .right:
                var firstColumn = [Tile]()
                for line in board.grid {
                    firstColumn.append(line.first!)
                }
                if let chosen = findEmptyTile(array: firstColumn) {
                    board.grid[chosen][0].value = 2
                }
            }
        }
    }

    // The findEmptyTile method is used to find an empty tile on the game board.
    // This function gets the array where we should drop a new 2 tile,
    // finds a tile that's empty and returns it's index randomly
    fileprivate func findEmptyTile(array: [Tile]) -> Int? {
        let available = array.indexes(of: Tile(value: 0))
        return available.randomElement()
    }

    fileprivate func checkState() {
        // here it checks if all the spaces are occuppied
        let values = board.grid.flatMap { $0 }.filter { $0.value == 0 }

        var movesAvailable = false

        for line in 0...boardSize-1 {
            for row in 0...boardSize-2
                where board.grid[line][row].value == board.grid[line][row+1].value {
                    movesAvailable = true
                }

            for row in 0...boardSize-1 {
                if line == boardSize-1 {
                    break
                }
                if board.grid[line][row].value == board.grid[line+1][row].value {
                    movesAvailable = true
                }
            }
        }

        if values.isEmpty && movesAvailable == false {
            state = .over
        }

        if board.grid.flatMap({ $0 }).filter({ $0.value == 2048 }).count > 1
            && movesAvailable == false {
            state = .won
        }
    }

    enum MoveDirection {
        // swiftlint:disable identifier_name
        case up
        case down
        case left
        case right
    }

    fileprivate func moveRight() {
        withAnimation(.easeInOut(duration: 0.3)) {
            for lineNumber in 0...boardSize-1 {
                let backwardsArray = board.grid[lineNumber].map { $0.value }
                let newArray = transformArray(array: backwardsArray.reversed() )
                var newLine = [Tile]()
                for value in newArray {
                    newLine.append(Tile(value: value))
                }
                board.grid[lineNumber] = newLine.reversed()
            }
        }
    }

    fileprivate func moveLeft() {
        withAnimation(.easeInOut(duration: 0.3)) {
            for lineNumber in 0...boardSize-1 {
                let newArray = transformArray(array: board.grid[lineNumber].map { $0.value })
                var newLine = [Tile]()
                for value in newArray {
                    newLine.append(Tile(value: value))
                }
                board.grid[lineNumber] = newLine
            }
        }
    }

    fileprivate func moveUp() {
        withAnimation(.easeInOut(duration: 0.3)) {
            for row in 0...boardSize-1 {
                var values = [Int]()
                for line in 0...boardSize-1 {
                    values.append(board.grid[line][row].value)
                }
                let newArray = transformArray(array: values)
                for line in 0...boardSize-1 {
                    board.grid[line][row].value = newArray[line]
                }
            }
        }
    }

    fileprivate func moveDown() {
        withAnimation(.easeInOut(duration: 0.3)){
            for row in 0...boardSize-1 {
                var values = [Int]()
                for line in 0...boardSize-1 {
                    values.append(board.grid[line][row].value)
                }
                var newArray = transformArray(array: values.reversed())
                newArray.reverse()
                for line in 0...boardSize-1 {
                    board.grid[line][row].value = newArray[line]
                }
            }
        }
    }

    // The move method is responsible for moving the tiles on the game board in a certain direction.
    // It takes one parameter, direction, which represents the direction in which the tiles should be moved.
    func move(direction: MoveDirection) {
        let preMoveBoard = board

        switch direction {
        case .down:
            moveDown()
        case .up:
            moveUp()
        case .left:
            moveLeft()
        case .right:
            moveRight()
        }

        // After moving the tiles, the method calls the checkState method
        // to check if the game is over or if the player has won.
        checkState()

        // This only happens when there was no change in the board
        // If the score did not change, the method calls the dropRandomTile method
        // and passes in the direction parameter to drop a new tile on the game board.

        if preMoveBoard != board {
            dropRandomTile(direction: direction)
        }
    }

    func transformArray(array: [Int]) -> [Int] {
        var newArray = [Int]()

        // Joins all numeric values together
        for position in 0...array.count-1 where array[position] != 0 { newArray.append(array[position]) }

        // Iterates new array to merge values, to the second to last element.
        // If duplicates found, doubles the first and eliminates the second
        if newArray.count > 1 {
            for position in 0...newArray.count-2 where newArray[position] == newArray[position+1] {
                    newArray[position] = newArray[position] * 2
                    score += newArray[position]
                    newArray[position+1] = 0
                }
        }

        newArray = newArray.filter({ $0 != 0 })

        // get the difference between old and new array and add zeroes to the end
        if newArray != array {
            let diff = (array.count)-(newArray.count)
            for _ in 1...diff {
                newArray.append(0)
            }
        }

        return newArray
    }
}
