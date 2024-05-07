//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import FeatherModuleKit

public protocol FileResourceInterface: Sendable {

    func list(
        _ input: File.Resource.List.Query
    ) async throws -> File.Resource.List

    func require(
        _ id: ID<File.Resource>
    ) async throws -> File.Resource.Detail

    func bulkDelete(
        ids: [ID<File.Resource>]
    ) async throws

}
