//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import FeatherModuleKit

public protocol FileUploadInterface: Sendable {

    func list(
        _ input: File.Upload.List.Query
    ) async throws -> File.Upload.List

    func require(
        _ id: ID<File.Upload>
    ) async throws -> File.Upload.ChunkedDetail

    func bulkDelete(
        ids: [ID<File.Upload>]
    ) async throws

}
