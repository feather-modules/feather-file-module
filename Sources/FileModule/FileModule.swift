import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import Logging
import FileModuleKit

public struct FileModule: FileModuleInterface {

    let components: ComponentRegistry
    let logger: Logger

    public init(
        components: ComponentRegistry,
        logger: Logger = .init(label: "file-module")
    ) {
        self.components = components
        self.logger = logger
    }

    public var storage: FileStorageInterface {
        StorageController(
            components: components,
            file: self
        )
    }
}
