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

struct UploadController: FileUploadInterface,
                            ControllerGet,
                            ControllerList
{
    typealias Detail = File.Upload.ChunkedDetail
    typealias List = File.Upload.List
    typealias Query = File.Upload.Query

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
            .key
        ]
    
    func bulkDelete(ids: [ID<File.Upload>]) async throws {
        
    }
}
