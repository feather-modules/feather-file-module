import FeatherDatabase
import FileModuleKit

extension File.Upload {

    public struct Model: KeyedDatabaseModel {
        public typealias KeyType = Key<File.Upload>

        public enum CodingKeys: String, DatabaseColumnName {
            case key
            case resourceKey
            case storageKey
        }
        public static let columnNames = CodingKeys.self
        public static let keyName = ColumnNames.key
        public static let tableName = "file_upload"

        public let key: KeyType
        public let resourceKey: Key<File.Resource>
        public let storageKey: String

        public init(
            key2: KeyType,
            resourceKey: Key<File.Resource>,
            storageKey: String
        ) {
            self.key = key2
            self.resourceKey = resourceKey
            self.storageKey = storageKey
        }
    }
}
