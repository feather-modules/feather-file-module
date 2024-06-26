//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

import FeatherModuleKit
import NIOCore

extension File.Chunk {

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case uploadId
                    case number
                }

                public let by: Keys
                public let order: Order

                public init(by: Keys, order: Order) {
                    self.by = by
                    self.order = order
                }
            }

            public let search: String?
            public let sort: Sort
            public let page: Page

            public init(
                search: String? = nil,
                sort: Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: Object {
            public let uploadId: ID<File.Upload>
            public let number: Int

            public init(
                uploadId: ID<File.Upload>,
                number: Int
            ) {
                self.uploadId = uploadId
                self.number = number
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct Detail: Object {
        public let uploadId: ID<File.Upload>
        public let number: Int

        public init(
            uploadId: ID<File.Upload>,
            number: Int
        ) {
            self.uploadId = uploadId
            self.number = number
        }
    }

    public struct Upload: Object {
        public let data: ByteBuffer

        public init(
            data: ByteBuffer
        ) {
            self.data = data
        }
    }
}
