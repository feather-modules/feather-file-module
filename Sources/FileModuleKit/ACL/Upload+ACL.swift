//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

import FeatherACL

extension Permission {

    static func fileUpload(_ action: Action) -> Self {
        .file("upload", action: action)
    }
}

extension File.Upload {

    public enum ACL: ACLSet {

        public static let list: Permission = .fileUpload(.list)
        public static let detail: Permission = .fileUpload(.detail)
        public static let upload: Permission = .fileUpload(.custom("upload"))

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.upload,
        ]
    }
}
