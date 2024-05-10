import FeatherComponent
import FeatherDatabase
import FeatherScripts
import FileModuleDatabaseKit
import FileModuleKit

extension File {

    public enum Migrations {

        public enum V1: Script {

            public static func run(
                _ components: ComponentRegistry
            ) async throws {
                let db = try await components.database().connection()

                try await Resource.Table.create(on: db)
                try await Upload.Table.create(on: db)
                try await Chunk.Table.create(on: db)
            }
        }
    }
}
