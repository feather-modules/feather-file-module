//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/01/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FileModuleDatabaseKit
import FileModuleKit
import Logging

struct ResourceController: FileResourceInterface,
    ControllerGet,
    ControllerList
{
    typealias Detail = File.Resource.Detail
    typealias List = File.Resource.List
    typealias Query = File.Resource.Query

    let components: ComponentRegistry
    let file: FileModuleInterface

    public init(
        components: ComponentRegistry,
        file: FileModuleInterface
    ) {
        self.components = components
        self.file = file
    }

    // MARK: -

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .key,
            .sizeInBytes,
        ]

    func bulkDelete(ids: [ID<File.Resource>]) async throws {

    }
}
