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

    func createChunked() async throws -> File.Upload.ChunkedDetail

    func finishChunked(_ id: ID<File.Upload>) async throws
        -> File.Upload.FinishChunkedDetail

    func abortChunked(_ id: ID<File.Upload>) async throws

    func simpleUpload(_ data: File.BinaryData) async throws
        -> File.Upload.SimpleDetail
}
