import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import FileModuleDatabaseKit
import FileModuleKit

extension File.Storage.Model: ModelInterfaceCreate, ModelInterfaceUpdate,
    ModelInterfacePatch
{
    public init(create: File.Storage.Create) throws {
        self.init(
            key: create.key.toKey(),
            value: create.value,
            name: create.name,
            notes: create.notes
        )
    }

    public init(update: File.Storage.Update, oldModel: Self) throws {
        self.init(
            key: update.key.toKey(),
            value: update.value,
            name: update.name,
            notes: update.notes
        )
    }

    public init(patch: File.Storage.Patch, oldModel: Self) throws {
        self.init(
            key: patch.key?.toKey() ?? oldModel.key,
            value: patch.value ?? oldModel.value,
            name: patch.name ?? oldModel.name,
            notes: patch.notes ?? oldModel.notes
        )
    }
}

extension File.Storage.Model.ColumnNames: ModelColumnNamesInterface {
    public init(listQuerySortKeys: File.Storage.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .key:
            self = .key
        case .name:
            self = .name
        case .value:
            self = .value
        }
    }
}

extension File.Storage.List: ListInterface {
    public init(items: [File.Storage.Model], count: UInt) throws {
        self.init(
            items: items.map {
                .init(key: $0.key.toID(), value: $0.value, name: $0.name)
            },
            count: count
        )
    }
}

extension File.Storage.List.Query: ListQueryInterface {}

extension File.Storage.List.Query.Sort: ListQuerySortInterface {}

extension File.Storage.Reference: ReferenceInterface {
    public init(model: File.Storage.Model) throws {
        self.init(key: model.key.toID(), value: model.value)
    }
}

extension File.Storage.Detail: DetailInterface {
    public init(model: File.Storage.Model) throws {
        self.init(
            key: model.key.toID(),
            value: model.value,
            name: model.name,
            notes: model.notes
        )
    }
}

extension File.Storage.Create: CreateInterface {}

extension File.Storage.Update: UpdateInterface {}

extension File.Storage.Patch: PatchInterface {}

extension File.Storage: ControllerModelInterface {}
