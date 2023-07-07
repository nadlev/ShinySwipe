//
//  User.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import Foundation
import SwiftUI

struct UserModel {
    private(set) var user: [String]
    private(set) var point: [Int]
    
    private let database = UserDefaults.standard
    
    init() {
        user = database.object(forKey: "User") as? [String] ?? []
        point = database.object(forKey: "Point") as? [Int] ?? []
    }
    
    func getUsers() -> [String] {
        return user
    }
    
    func getPoints() -> [Int] {
        return point
    }
    
    mutating func addUser(_ info: String) {
        user.append(info)
        database.set(user, forKey: "User")
        print(user)
    }
    
    mutating func addPoint(_ score: Int) {
        point.append(score)
        database.set(point, forKey: "Point")
        print(point)
    }
    
    func getPoint(name: String) -> Int {
        let index = user.firstIndex(of: name) ?? 0
        return point[index]
    }
    
    mutating func updateLastPoint(point: Int) {
        guard !user.isEmpty else {
            // No users, can't update point
            return
        }
        
        let idx = user.count - 1
        self.point[idx] = point
        database.set(self.point, forKey: "Point")
    }

}
