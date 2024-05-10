import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import FileModuleDatabaseKit
import FileModuleKit
import NanoID

extension File.Resource.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: File.Resource.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .id:
            self = .key
        case .sizeInBytes:
            self = .sizeInBytes
        }
    }
}

extension File.Resource.List.Item: ListItemAdapter {
    public init(model: File.Resource.Model) throws {
        self.init(id: model.key.toID(), sizeInBytes: model.sizeInBytes)
    }
}

extension File.Resource.List: ListAdapter {
    public typealias Model = File.Resource.Model
}

extension File.Resource.Detail: DetailAdapter {
    public init(model: File.Resource.Model) throws {
        self.init(id: model.key.toID(), sizeInBytes: model.sizeInBytes)
    }
}
