//
//  File.swift
//
//
//  Created by mzperx on 07/05/2024.
//
import FeatherDatabase
import FeatherModuleKit
import FileModuleKit

extension ID<File.Resource> {
    static func removeLastPathComponent(_ input: String) -> String {
        var components = input.components(separatedBy: "/")
        if components.count > 1 {
            components.removeLast()
        }
        let result = components.joined(separator: "/")
        return result
    }

    public func toStorageFileKey() -> String {
        var result = ""
        var charCount = 0

        for char in self.rawValue {
            result.append(char)
            charCount += 1

            if charCount % 4 == 0 {
                result.append("/")
            }
        }

        return result
    }

    public func toStorageFolderKey() -> String {
        Self.removeLastPathComponent(toStorageFileKey())
    }
}

extension Key<File.Resource> {
    public func toStorageFileKey() -> String {
        toID().toStorageFileKey()
    }

    public func toStorageFolderKey() -> String {
        toID().toStorageFolderKey()
    }
}
