//
//  UserVM.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import Foundation

class UserVM: ObservableObject {
    @Published private var model = UserModel()
    
    func getUsers() -> [String] {
        model.getUsers()
    }
    
    func getPoint(name: String) -> Int {
        model.getPoint(name: name)
    }
    
    func addUser(_ info: String) {
        print(info)
        model.addUser(info)
        model.addPoint(0)
    }
    
    func addPoint(_ score: Int) {
        model.addPoint(score)
        print(score)
    }
    
    func getPoints() -> [Int] {
        model.getPoints()
    }
    
    func updatePoint(point: Int) {
        model.updateLastPoint(point: point)
    }
}
