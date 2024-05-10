// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-file-module",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "FileModule", targets: ["FileModule"]),
        .library(name: "FileModuleKit", targets: ["FileModuleKit"]),
        .library(name: "FileModuleDatabaseKit", targets: ["FileModuleDatabaseKit"]),
        .library(name: "FileModuleMigrationKit", targets: ["FileModuleMigrationKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.61.0"),
        .package(url: "https://github.com/feather-framework/feather-module-kit", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/feather-framework/feather-database-driver-sqlite", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-component", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/feather-framework/feather-storage-driver-memory", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/feather-framework/feather-storage-driver-local", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/feather-framework/feather-storage-driver-s3", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/soto-project/soto", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "FileModuleKit",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-module-kit"),
            ]
        ),

        .target(
            name: "FileModuleDatabaseKit",
            dependencies: [
                .target(name: "FileModuleKit"),
            ]
        ),
    
        .target(
            name: "FileModuleMigrationKit",
            dependencies: [
                .target(name: "FileModuleDatabaseKit"),
                .product(name: "FeatherMigrationKit", package: "feather-module-kit"),
            ]
        ),

        .target(
            name: "FileModule",
            dependencies: [
                .target(name: "FileModuleDatabaseKit"),
            ]
        ),

        .testTarget(
            name: "FileModuleKitTests",
            dependencies: [
                .target(name: "FileModuleKit")
            ]
        ),
        
        .testTarget(
            name: "FileModuleMigrationKitTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "FileModule"),
                .target(name: "FileModuleMigrationKit"),
                // drivers
                .product(name: "FeatherDatabaseDriverSQLite", package: "feather-database-driver-sqlite"),
                .product(name: "FeatherStorageDriverMemory", package: "feather-storage-driver-memory"),
                .product(name: "FeatherStorageDriverLocal", package: "feather-storage-driver-local"),
                .product(name: "FeatherStorageDriverS3", package: "feather-storage-driver-s3"),
                .product(name: "SotoS3", package: "soto"),
            ]
        ),
    
        .testTarget(
            name: "FileModuleTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "FileModule"),
                .target(name: "FileModuleMigrationKit"),
                // drivers
                .product(name: "FeatherDatabaseDriverSQLite", package: "feather-database-driver-sqlite"),
                .product(name: "FeatherStorageDriverMemory", package: "feather-storage-driver-memory"),
                .product(name: "FeatherStorageDriverLocal", package: "feather-storage-driver-local"),
                .product(name: "FeatherStorageDriverS3", package: "feather-storage-driver-s3"),
                .product(name: "SotoS3", package: "soto"),
            ]
        ),
        
    ]
)
