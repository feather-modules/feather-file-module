//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/01/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Logging
import FileModuleDatabaseKit
import FileModuleKit

struct ChunkController: FileChunkInterface,
                            ControllerGet,
                            ControllerList
{
    typealias Detail = File.Chunk.Detail
    typealias List = File.Chunk.List
    typealias Query = File.Chunk.Query

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
            .uploadKey,
            .number,
        ]
    
    func bulkDelete(ids: [ID<File.Chunk>]) async throws {
        
    }
}
