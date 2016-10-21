//
//  dotExport.swift
//  AsyncBT
//
//  Created by Maxim Zaks on 20.10.16.
//  Copyright © 2016 Maxim Zaks. All rights reserved.
//

import Foundation


protocol DotExportable {
    var label : String {get}
    var connectedTo : [DotExportable] {get}
}

extension BehaviourNode {
    var label : String {
        return "\(type(of: self))"
    }
    var connectedTo : [DotExportable] {
        return []
    }
}

extension Action {
    var label : String {
        return "\(Self.self)<\(Self.T.self)>"
    }
}

extension SequenceNode {
    var label : String {
        return "=>"
    }
    var connectedTo : [DotExportable] {
        return children
    }
}

extension SelectorNode {
    var label : String {
        return "??"
    }
    var connectedTo : [DotExportable] {
        return children
    }
}

extension Decorator {
    var connectedTo : [DotExportable] {
        return [node]
    }
}

fileprivate class Container {
    var lines : [String] = []
    func append(_ s : String){
        lines.append(s)
    }
    init() {
    }
}

extension DotExportable {
    
    var dotNotation : String {
        var container = Container()
        container.append("digraph G {")
        func appendLabelAndChildren(node : DotExportable, index : Int, container : Container) -> Int{
            container.append("  n\(index) [label=\"\(node.label)\"];")
            if node.connectedTo.count == 0 {
                container.append("  n\(index) [shape=box];")
                return index
            }
            var childIndex = index
            for child in node.connectedTo {
                container.append("  n\(index) -> n\(childIndex+1);")
                childIndex = appendLabelAndChildren(node: child, index: childIndex+1, container: container)
            }
            return childIndex
        }
        _ = appendLabelAndChildren(node: self, index: 0, container: container)
        container.append("}")
        return container.lines.joined(separator: "\n")
    }
}
