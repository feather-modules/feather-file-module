//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import FeatherModuleKit

public protocol FileChunkInterface: Sendable {

    func list(
        _ input: File.Chunk.List.Query
    ) async throws -> File.Chunk.List

    func require(
        _ id: ID<File.Chunk>
    ) async throws -> File.Chunk.Detail

    func require(uploadId: ID<File.Upload>, number: Int) async throws
        -> File.Chunk.Detail

    func upload(
        uploadId: ID<File.Upload>,
        number: Int,
        data: File.BinaryData
    ) async throws -> File.Chunk.Detail

    func remove(ids: [ID<File.Chunk>]) async throws

    func remove(_ id: ID<File.Chunk>) async throws

    func remove(_ list: [(uploadId: ID<File.Upload>, number: Int)]) async throws

    func remove(uploadId: ID<File.Upload>, number: Int) async throws
}
