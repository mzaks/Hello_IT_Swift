//
//  AsyncBT.swift
//  AsyncBT
//
//  Created by Maxim Zaks on 19.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import Foundation


enum BehaviourResult : Equatable {
    case succeeded, failed, panicked(reason : String)
}

func ==(lv: BehaviourResult, rv : BehaviourResult) -> Bool {
    switch (lv, rv) {
    case (.succeeded, .succeeded):
        return true
    case (.failed, .failed):
        return true
    case (.panicked, .panicked):
        return true
    default:
        return false
    }
}

protocol DataType {}

extension DataType{
    func convertOrDie<T>(with callback: @escaping (DataType, BehaviourResult) -> ())->T!{
        guard let result = self as? T else {
            callback(self, .panicked(reason: "could not convert [\(self)] to type \(T.self)"))
            return nil
        }
        return result
    }
}

protocol BehaviourNode : DotExportable {
    func execute(data : DataType, callback : @escaping(_ data: DataType, _ result : BehaviourResult)->())
}

protocol Decorator : BehaviourNode {
    var node : BehaviourNode {get}
}

struct SelectorNode : BehaviourNode {
    let children : [BehaviourNode]
    func execute(data : DataType, callback : @escaping(_ data: DataType, _ result : BehaviourResult)->()){
        guard children.count > 0 else {
            callback(data, .failed)
            return
        }
        var index = 0
        let node = children[index]
        func handleResult(_ data: DataType, _ result : BehaviourResult){
            guard result == .failed else {
                callback(data, result)
                return
            }
            index+=1
            guard index < children.count else {
                callback(data, .failed)
                return
            }
            children[index].execute(data: data, callback: handleResult)
        }
        node.execute(data: data, callback: handleResult)
    }
}


struct SequenceNode : BehaviourNode {
    let children : [BehaviourNode]
    func execute(data : DataType, callback : @escaping(_ data: DataType, _ result : BehaviourResult)->()){
        guard children.count > 0 else {
            callback(data, .failed)
            return
        }
        var index = 0
        let node = children[index]
        func handleResult(_ data: DataType, _ result : BehaviourResult){
            guard result == .succeeded else {
                callback(data, result)
                return
            }
            index+=1
            guard index < children.count else {
                callback(data, .succeeded)
                return
            }
            children[index].execute(data: data, callback: handleResult)
        }
        node.execute(data: data, callback: handleResult)
    }
}

protocol Action : BehaviourNode {
    associatedtype T : DataType
    func execute(data: T, callback: @escaping (DataType, BehaviourResult) -> ())
}

extension Action {
    func execute(data: DataType, callback: @escaping (DataType, BehaviourResult) -> ()) {
        guard let data : T = data.convertOrDie(with: callback) else {
            return
        }
        execute(data: data, callback: callback)
    }
}


prefix operator =>
prefix operator ??

prefix func =>(children : [BehaviourNode]) -> BehaviourNode{
    return SequenceNode(children: children)
}

prefix func ??(children : [BehaviourNode]) -> BehaviourNode{
    return SelectorNode(children: children)
}
