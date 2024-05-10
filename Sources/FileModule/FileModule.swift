import FeatherComponent
import FeatherModuleKit
import FeatherStorage
import FeatherValidation
import FileModuleKit
import Logging

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

    public var resource: FileResourceInterface {
        ResourceController(
            components: components,
            file: self
        )
    }

    public var upload: FileUploadInterface {
        UploadController(
            components: components,
            file: self
        )
    }

    public var chunk: FileChunkInterface {
        ChunkController(
            components: components,
            file: self
        )
    }
}
