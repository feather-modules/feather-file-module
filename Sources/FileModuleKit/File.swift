import FeatherACL
import FeatherModuleKit
import FeatherStorage
import NIOCore

extension FeatherACL.Permission {

    static func file(_ context: String, action: Action) -> Self {
        .init(namespace: "file", context: context, action: action)
    }
}

public enum File {
    public typealias BinaryData = ByteBuffer

    public enum ACL: ACLSet {

        public static var all: [FeatherACL.Permission] {
            Resource.ACL.all + Upload.ACL.all + Chunk.ACL.all
        }
    }

    public enum Error: Swift.Error {
        case unknown
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
