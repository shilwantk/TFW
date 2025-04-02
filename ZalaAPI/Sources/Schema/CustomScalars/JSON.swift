// @generated
// This file was automatically generated and can be edited to
// implement advanced custom scalar functionality.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

import ApolloAPI
import Foundation

/// Represents untyped JSON
//public typealias JSON = String

public enum JSON: CustomScalarType, Hashable {
    case dictionary([String: AnyHashable])
    case array([AnyHashable])
    
    
    public init(_jsonValue value: JSONValue) throws {
        if let jsonString = value as? String {
            guard let jsonData = jsonString.data(using: .utf8) else {
                throw JSONDecodingError.couldNotConvert(value: value, to: JSON.self)
            }
            
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyHashable] {
                    self = .dictionary(jsonDictionary)
                } else {
                    throw JSONDecodingError.couldNotConvert(value: value, to: JSON.self)
                }
            } catch {
                print("Error decoding JSON string: \(error)")
                throw JSONDecodingError.couldNotConvert(value: value, to: JSON.self)
            }
        } else if let dict = value as? [String: AnyHashable] {
            self = .dictionary(dict)
        } else if let array = value as? [AnyHashable] {
            self = .array(array)
        } else {
            throw JSONDecodingError.couldNotConvert(value: value, to: JSON.self)
        }
    }
    
    public var _jsonValue: JSONValue {
        switch self {
        case let .dictionary(json as AnyHashable),
            let .array(json as AnyHashable):
            return json
        }
    }
    
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        lhs._jsonValue == rhs._jsonValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_jsonValue)
    }
}

