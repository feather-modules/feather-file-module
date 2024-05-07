import FeatherACL
import FeatherModuleKit

extension FeatherACL.Permission {

    static func file(_ context: String, action: Action) -> Self {
        .init(namespace: "file", context: context, action: action)
    }
}

public typealias ByteArray = [UInt8]  //TODO: replace for the appropriate one

public enum File {

    public enum ACL: ACLSet {

        public static var all: [FeatherACL.Permission] {
            Resource.ACL.all
        }
    }

    public enum Error: Swift.Error {
        case unknown
        case chunkNumberAlreadyExists(uploadId: ID<Upload>, number: Int)
    }

    public enum Resource: Identifiable {}
    public enum Upload: Identifiable {}
    public enum Chunk: Identifiable {}
}

public protocol FileModuleInterface: ModuleInterface {
    var resource: FileResourceInterface { get }
    var upload: FileUploadInterface { get }
    var chunk: FileChunkInterface { get }
}
