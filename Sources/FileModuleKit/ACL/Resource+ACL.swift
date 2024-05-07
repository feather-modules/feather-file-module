//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

import FeatherACL

extension Permission {

    static func fileResource(_ action: Action) -> Self {
        .file("resource", action: action)
    }
}

extension File.Resource {

    public enum ACL: ACLSet {

        public static let list: Permission = .fileResource(.list)
        public static let detail: Permission = .fileResource(.detail)
        public static let create: Permission = .fileResource(.create)
        public static let update: Permission = .fileResource(.update)
        public static let delete: Permission = .fileResource(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.update,
            Self.delete,
        ]
    }
}
