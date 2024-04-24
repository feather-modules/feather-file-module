//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

import FeatherACL

extension Permission {

    static func fileStorage(_ action: Action) -> Self {
        .file("storage", action: action)
    }
}

extension File.Storage {

    public enum ACL: ACLSet {

        public static let list: Permission = .fileStorage(.list)
        public static let detail: Permission = .fileStorage(.detail)
        public static let create: Permission = .fileStorage(.create)
        public static let update: Permission = .fileStorage(.update)
        public static let delete: Permission = .fileStorage(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.update,
            Self.delete,
        ]
    }
}
