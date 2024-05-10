import FeatherDatabase
import FileModuleKit

extension File.Chunk {

    public struct Model: KeyedDatabaseModel {
        public typealias KeyType = Key<File.Chunk>

        public enum CodingKeys: String, DatabaseColumnName {
            case key
            case uploadKey
            case number
            case storageKey
        }
        public static let columnNames = CodingKeys.self
        public static let keyName = ColumnNames.key
        public static let tableName = "file_chunk"

        public let key: KeyType
        public let uploadKey: Key<File.Upload>
        public let number: Int
        public let storageKey: String

        public init(
            key: KeyType,
            uploadKey: Key<File.Upload>,
            number: Int,
            storageKey: String
        ) {
            self.key = key
            self.uploadKey = uploadKey
            self.number = number
            self.storageKey = storageKey
        }
    }
}
