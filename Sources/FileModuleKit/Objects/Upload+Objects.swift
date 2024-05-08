//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

import FeatherModuleKit

extension File.Upload {

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case id
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
            public let id: ID<File.Upload>

            public init(id: ID<File.Upload>) {
                self.id = id
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

    public struct SimpleDetail: Object {
        public let resourceId: ID<File.Resource>

        public init(resourceId: ID<File.Resource>) {
            self.resourceId = resourceId
        }
    }

    public struct ChunkedDetail: Object {
        public let uploadId: ID<File.Upload>

        public init(uploadId: ID<File.Upload>) {
            self.uploadId = uploadId
        }
    }

    public struct FinishChunkedDetail: Object {
        public let resourceId: ID<File.Resource>

        public init(resourceId: ID<File.Resource>) {
            self.resourceId = resourceId
        }
    }
}
