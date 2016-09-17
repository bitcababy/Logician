//
//  Variable.swift
//  Logician
//
//  Created by Matt Diephouse on 9/2/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Foundation

/// A class used to provide identity to `Variable`s.
private class Identity { }

public protocol VariableProtocol: PropertyProtocol {
    /// The type of value that the variable represents.
    associatedtype Value
    
    /// Extracts the variable from the receiver.
    var variable: Variable<Value> { get }
}

/// An unknown value in a logic problem.
public struct Variable<Value> {
    /// The identity of the variable.
    fileprivate let identity: Identity
    
    /// Create a new variable.
    public init() {
        identity = Identity()
    }
    
    public func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> Property<NewValue> {
        return Property<NewValue>(self, transform)
    }
    
    /// A type-erased version of the variable.
    internal var erased: AnyVariable {
        return AnyVariable(identity: identity)
    }
}

extension Variable: VariableProtocol {
    public var property: Property<Value> {
        return Property(self, { $0 })
    }
    
    public var variable: Variable<Value> {
        return self
    }
}

/// A type-erased, hashable `Variable`.
internal struct AnyVariable: Hashable {
    fileprivate let identity: Identity
    
    /// Create a variable with an existing `Identity`.
    fileprivate init(identity: Identity) {
        self.identity = identity
    }
    
    var hashValue: Int {
        return ObjectIdentifier(identity).hashValue
    }
    
    static func ==(lhs: AnyVariable, rhs: AnyVariable) -> Bool {
        return lhs.identity === rhs.identity
    }
}

/// Test whether the variables have the same identity.
internal func == <Left, Right>(lhs: Variable<Left>, rhs: Variable<Right>) -> Bool {
    return lhs.identity === rhs.identity
}

/// Test whether the variables have the same identity.
internal func == <Value>(lhs: Variable<Value>, rhs: AnyVariable) -> Bool {
    return lhs.identity === rhs.identity
}

/// Test whether the variables have the same identity.
internal func == <Value>(lhs: AnyVariable, rhs: Variable<Value>) -> Bool {
    return lhs.identity === rhs.identity
}
