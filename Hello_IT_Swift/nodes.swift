//
//  nodes.swift
//  AsyncBT
//
//  Created by Maxim Zaks on 20.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import Foundation

struct GoodMorning : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 6 && hour < 12 {
            print("Good morningn \(data)")
            callback(data, .succeeded)
        } else {
            callback(data, .failed)
        }
    }
}

struct GoodDay : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 12 && hour < 17 {
            print("Good day \(data)")
            callback(data, .succeeded)
        } else {
            callback(data, .failed)
        }
    }
}

struct GoodEvening : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 17 && hour < 20 {
            print("Good evening \(data)")
            callback(data, .succeeded)
        } else {
            callback(data, .failed)
        }
    }
}

struct GoodNight : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 20 || hour < 6 {
            print("You are up late \(data)")
            callback(data, .succeeded)
        } else {
            callback(data, .failed)
        }
    }
}

struct Introduction : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        print("Hello IT,")
        callback(data, .succeeded)
    }
}

struct AskingForUsersName : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        print("Who am I talking to?")
        let name = readLine()
        if let name = name, name.utf8.count > 0{
            callback(name, .succeeded)
        } else {
            callback(data, .failed)
        }
    }
}

struct ResponseToAnnonymousUser : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        print("Ah you want to stay anonymous, that's fine...")
        callback(data, .succeeded)
    }
}

struct WhatIsYoureEmergency : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        print("What is your emergency?")
        if let problemDescription = readLine() {
            callback(problemDescription, .succeeded)
        } else {
            callback(data, .failed)
        }
    }
}

struct GoodBye : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        print("Cheers mate!")
        callback(data, .succeeded)
    }
}

struct HaveYoutriedToTurnItOffAndOnAgain : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        print("Have you tried to turn it off and on again?")
        callback(data, .succeeded)
    }
}

struct YesNoQuestion : Action {
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        print("[yes/no]")
        if let answer = readLine(), answer == "yes" {
            callback(answer, .succeeded)
        } else {
            callback(data, .failed)
        }
    }
}

class Counter{
    var _count = 0
    var count : Int {return _count}
    func increase(){
        _count += 1
    }
}
struct IsItPlugedIn : Action {
    var counter = Counter()
    func execute(data: String, callback: @escaping (DataType, BehaviourResult) -> ()) {
        let realy = [String](repeating: " realy", count: counter.count).joined(separator: ",")
        print("Is it\(realy) plugged in?")
        counter.increase()
        callback(data, .succeeded)
    }
}

struct RepeatOnSuccess : Decorator {
    let node : BehaviourNode
    let counter = Counter()
    func execute(data: DataType, callback: @escaping (DataType, BehaviourResult) -> ()) {
        func repeatExecution(data : DataType, result : BehaviourResult) -> (){
            if result == .succeeded {
                if counter.count < 3 {
                    counter.increase()
                } else {
                    print("Sorry can't help you mate.")
                    callback(data, .panicked(reason: "This is pointless"))
                    return
                }
                node.execute(data: data, callback: repeatExecution)
            } else {
                callback(data, result)
            }
        }
        node.execute(data: data, callback: repeatExecution)
    }
}
