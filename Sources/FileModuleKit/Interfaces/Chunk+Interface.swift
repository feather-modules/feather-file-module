//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import FeatherModuleKit
import NIOCore

public protocol FileChunkInterface: Sendable {

    func list(
        uploadId: ID<File.Upload>,
        _ input: File.Chunk.List.Query
    ) async throws -> File.Chunk.List

    func require(uploadId: ID<File.Upload>, number: Int) async throws
        -> File.Chunk.Detail

    func upload(
        uploadId: ID<File.Upload>,
        number: Int,
        data: ByteBuffer
    ) async throws -> File.Chunk.Detail

    func bulkDelete(ids: [ID<File.Chunk>]) async throws

    func delete(_ id: ID<File.Chunk>) async throws

    func bulkDelete(uploadId: ID<File.Upload>, numbers: [Int]) async throws

    func delete(uploadId: ID<File.Upload>, number: Int) async throws
}
