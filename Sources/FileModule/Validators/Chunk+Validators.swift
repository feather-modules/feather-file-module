//
//  File.swift
//
//
//  Created by Tibor Bodecs on 15/02/2024.
//

import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import FileModuleDatabaseKit
import FileModuleKit

extension File.Chunk {

    enum Validators {
    }
}

//TODO: move into the controller
//extension File.Chunk.Upload {
//
//    public func verify(
//        uploadId: ID<File.Upload>,
//        number: Int,
//        on db: Database) async throws
//    {
//        try await File.Upload.Query.require(uploadId.toKey(), on: db)
//        
//        //TODO: filter uploadId and number and throw Error.chunkNumberAlreadyExists
//        //Query.count(filter: , on:    )
////        throw File.Error.chunkNumberAlreadyExists(uploadId: uploadId, number: number)
//    }
//}
