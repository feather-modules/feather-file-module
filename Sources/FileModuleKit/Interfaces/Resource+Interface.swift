//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import FeatherModuleKit
import NIOCore

public protocol FileResourceInterface: Sendable {

    func list(
        _ input: File.Resource.List.Query
    ) async throws -> File.Resource.List

    func require(
        _ id: ID<File.Resource>
    ) async throws -> File.Resource.Detail

    func download(_ id: ID<File.Resource>, range: ClosedRange<UInt64>?)
        async throws -> ByteBuffer

    func bulkDelete(ids: [ID<File.Resource>]) async throws

    func delete(_ id: ID<File.Resource>) async throws
}
