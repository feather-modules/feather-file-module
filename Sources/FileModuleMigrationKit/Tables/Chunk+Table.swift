import FeatherDatabase
import FileModuleDatabaseKit
import FileModuleKit

extension File.Chunk {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.key),
            StringColumn(Model.ColumnNames.uploadKey),
            IntColumn(Model.ColumnNames.number),
            StringColumn(Model.ColumnNames.storageKey),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            PrimaryKeyConstraint(Model.ColumnNames.key),
            UniqueConstraint([
                Model.ColumnNames.uploadKey, Model.ColumnNames.number,
            ]),
        ]
    }
}
