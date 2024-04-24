import FeatherDatabase
import FileModuleKit

extension File.Storage {

    public struct Model: KeyedDatabaseModel {
        public typealias KeyType = Key<File.Storage>

        public enum CodingKeys: String, DatabaseColumnName {
            case key
            case value
            case name
            case notes
        }
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.key
        public static let tableName = "file_storage"

        public let key: KeyType
        public let value: String
        public let name: String?
        public let notes: String?

        public init(
            key: KeyType,
            value: String,
            name: String? = nil,
            notes: String? = nil
        ) {
            self.key = key
            self.value = value
            self.name = name
            self.notes = notes
        }
    }
}
