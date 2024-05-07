import FeatherDatabase
import FileModuleDatabaseKit
import FileModuleKit

extension File.Upload {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.key),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            PrimaryKeyConstraint(Model.ColumnNames.key)
        ]
    }
}
