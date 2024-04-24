import FeatherACL
import FeatherModuleKit

extension FeatherACL.Permission {

    static func file(_ context: String, action: Action) -> Self {
        .init(namespace: "file", context: context, action: action)
    }
}

public enum File {

    public enum ACL: ACLSet {

        public static var all: [FeatherACL.Permission] {
            Storage.ACL.all
        }
    }

    public enum Error: Swift.Error {
        case unknown
    }

    public enum Storage: Identifiable {}
}

public protocol FileModuleInterface: ModuleInterface {
    var storage: FileStorageInterface { get }
}
