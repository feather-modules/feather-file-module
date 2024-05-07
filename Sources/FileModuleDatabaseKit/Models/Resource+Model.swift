import FeatherDatabase
import FileModuleKit

extension File.Resource {

    public struct Model: KeyedDatabaseModel {
        public typealias KeyType = Key<File.Resource>

        public enum CodingKeys: String, DatabaseColumnName {
            case key
            case sizeInBytes
        }
        public static let columnNames = CodingKeys.self
        public static let keyName = ColumnNames.key
        public static let tableName = "file_resource"

        public let key: KeyType
        public let sizeInBytes: Int64

        public init(
            key: KeyType,
            sizeInBytes: Int64
        ) {
            self.key = key
            self.sizeInBytes = sizeInBytes
        }
    }
}
