import FeatherDatabase
import FileModuleDatabaseKit
import FileModuleKit

extension File.Resource {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.key),
            Int64Column(Model.ColumnNames.sizeInBytes),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            PrimaryKeyConstraint(Model.ColumnNames.key)
        ]
    }
}
