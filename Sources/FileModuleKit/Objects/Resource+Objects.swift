//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

import FeatherModuleKit

extension File.Resource {

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case id
                    case sizeInBytes
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
            public let id: ID<File.Resource>
            public let sizeInBytes: Int64

            public init(id: ID<File.Resource>, sizeInBytes: Int64) {
                self.id = id
                self.sizeInBytes = sizeInBytes
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
        public let id: ID<File.Resource>
        public let sizeInBytes: Int64

        public init(
            id: ID<File.Resource>,
            sizeInBytes: Int64
        ) {
            self.id = id
            self.sizeInBytes = sizeInBytes
        }
    }
}
