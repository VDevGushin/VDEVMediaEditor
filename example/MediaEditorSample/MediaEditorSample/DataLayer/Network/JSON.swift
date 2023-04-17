//
//  JSON.swift
//  W1D1NetworkLayer
//
//  Created by Алексей Лысенко on 08.04.2022.
//

import Foundation
import Apollo

@dynamicMemberLookup
public class JSON: JSONDecodable {
    private(set) public var jsonValue: [String: Any]
    
    public required init(jsonValue value: JSONValue) throws {
        self.jsonValue = (value as? [String: Any]) ?? [:]
    }
    
    public subscript(dynamicMember member: String) -> JSON? {
        guard let value = jsonValue[member] else { return nil }
        return try? JSON(jsonValue: value)
    }
    
    public subscript<T>(dynamicMember member: String) -> T? {
        return jsonValue[member] as? T
    }
}
