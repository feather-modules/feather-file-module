import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import FileModuleDatabaseKit
import FileModuleKit

extension File.Chunk.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: File.Chunk.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .id:
            self = .key
        case .uploadId:
            self = .uploadKey
        case .number:
            self = .number
        }
    }
}

extension File.Chunk.List.Item: ListItemAdapter {
    public init(model: File.Chunk.Model) throws {
        self.init(id: model.key.toID(), uploadId: model.uploadKey.toID(), number: model.number)
    }
}

extension File.Chunk.List: ListAdapter {
    public typealias Model = File.Chunk.Model
}

extension File.Chunk.Detail: DetailAdapter {
    public init(model: File.Chunk.Model) throws {
        self.init(id: model.key.toID(), uploadId: model.uploadKey.toID(), number: model.number)
    }
}
