import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import FileModuleDatabaseKit
import FileModuleKit
import NanoID

extension File.Upload.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: File.Upload.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .id:
            self = .key
        case .resourceId:
            self = .storageKey
        }
    }
}

extension File.Upload.List.Item: ListItemAdapter {
    public init(model: File.Upload.Model) throws {
        self.init(id: model.key.toID(), resourceId: model.resourceKey.toID())
    }
}

extension File.Upload.List: ListAdapter {
    public typealias Model = File.Upload.Model
}

extension File.Upload.ChunkedDetail: DetailAdapter {
    public init(model: File.Upload.Model) throws {
        self.init(id: model.key.toID(), resourceId: model.resourceKey.toID())
    }
}

extension File.Upload.SimpleDetail: DetailAdapter {
    public init(model: File.Resource.Model) throws {
        self.init(resourceId: model.key.toID())
    }
}

extension File.Upload.FinishChunkedDetail: DetailAdapter {
    public init(model: File.Upload.Model) throws {
        self.init(
            resourceId: model.resourceKey.toID()
        )
    }
}
