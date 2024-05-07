import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import FileModuleDatabaseKit
import FileModuleKit

extension File.Upload.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: File.Upload.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .id:
            self = .key
        }
    }
}

extension File.Upload.List.Item: ListItemAdapter {
    public init(model: File.Upload.Model) throws {
        self.init(id: model.key.toID())
    }
}

extension File.Upload.List: ListAdapter {
    public typealias Model = File.Upload.Model
}

extension File.Upload.ChunkedDetail: DetailAdapter {
    public init(model: File.Upload.Model) throws {
        self.init(uploadId: model.key.toID())
    }
}
