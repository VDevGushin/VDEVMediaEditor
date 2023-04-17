//
//  FilePlistStorage.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import Foundation

class FilePlistStorage {
    enum FileStorageError: Error {
        case containerDoesNotExist
        case fileDoesNotExist
    }

    let applicationGroupIdentifier: String

    static let widgetGroup = FilePlistStorage(applicationGroupIdentifier: "group.com.w1d1.ru.widget")

    private init(applicationGroupIdentifier: String) {
        self.applicationGroupIdentifier = applicationGroupIdentifier
    }

    @discardableResult
    func save(data: [String: Any], toFileNamed fileName: String) -> Bool {
        guard let containerPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: applicationGroupIdentifier) else {
            return false
        }
        let url = containerPath.appendingPathComponent(fileName).appendingPathExtension("plist")

        let dictionaryResult = NSDictionary(dictionary: data)
        return dictionaryResult.write(to: url, atomically: true)
    }

    func get<T: Decodable>(fromFileNamed fileName: String) throws -> T {
        guard let containerPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: applicationGroupIdentifier) else {
            throw FileStorageError.containerDoesNotExist
        }
        let url = containerPath.appendingPathComponent(fileName).appendingPathExtension("plist")
        guard let plistXML = FileManager.default.contents(atPath: url.path) else {
            throw FileStorageError.fileDoesNotExist
        }
        return try PropertyListDecoder().decode(T.self, from: plistXML)
    }
}
