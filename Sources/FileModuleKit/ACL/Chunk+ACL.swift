//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

import FeatherACL

extension Permission {

    static func fileChunk(_ action: Action) -> Self {
        .file("chunk", action: action)
    }
}

extension File.Chunk {

    public enum ACL: ACLSet {

        public static let list: Permission = .fileChunk(.list)
        public static let detail: Permission = .fileChunk(.detail)
        public static let upload: Permission = .fileChunk(.custom("upload"))
        public static let remove: Permission = .fileChunk(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.upload,
            Self.remove,
        ]
    }
}
