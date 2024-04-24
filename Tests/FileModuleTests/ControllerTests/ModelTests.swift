////
////  File.swift
////
////
////  Created by Tibor Bodecs on 06/03/2024.
////
//
//import FeatherModuleKit
//import FileModuleKit
//import XCTest
//
//@testable import FileModule
//
//extension File.Permission.Create {
//
//    static func mock() -> File.Permission.Create {
//        .init(
//            key: .init(rawValue: "foo.bar.baz"),
//            name: "foo",
//            notes: "bar"
//        )
//    }
//}
//
//final class PermissionTests: TestCase {
//
//    func testList() async throws {
//        _ = try await file.permission.create(
//            File.Permission.Create.mock()
//        )
//
//        let list = try await file.permission.list(
//            File.Permission.List.Query(
//                search: nil,
//                sort: .init(by: .key, order: .asc),
//                page: .init()
//            )
//        )
//
//        print(list)
//    }
//
//    func testCreate() async throws {
//        let detail = try await file.permission.create(
//            File.Permission.Create.mock()
//        )
//
//        XCTAssertEqual(detail.key.rawValue, "foo.bar.baz")
//        XCTAssertEqual(detail.name, "foo")
//        XCTAssertEqual(detail.notes, "bar")
//    }
//
//    func testReference() async throws {
//        let detail = try await file.permission.create(
//            File.Permission.Create.mock()
//        )
//
//        let permissions = try await file.permission.reference(
//            ids: [
//                detail.key
//            ]
//        )
//
//        XCTAssertEqual(permissions.count, 1)
//        XCTAssertEqual(permissions[0].key, detail.key)
//    }
//
//    func testDetail() async throws {
//        let detail = try await file.permission.create(
//            File.Permission.Create.mock()
//        )
//
//        let permission = try await file.permission.get(detail.key)
//        XCTAssertEqual(permission.key, detail.key)
//    }
//
//    func testUpdate() async throws {
//        let detail = try await file.permission.create(
//            File.Permission.Create.mock()
//        )
//
//        let permission = try await file.permission.update(
//            detail.key,
//            File.Permission.Update(
//                key: detail.key,
//                name: "name",
//                notes: nil
//            )
//        )
//        XCTAssertEqual(permission.key, detail.key)
//        XCTAssertEqual(permission.name, "name")
//        XCTAssertEqual(permission.notes, nil)
//    }
//
//    func testPatch() async throws {
//        let detail = try await file.permission.create(
//            File.Permission.Create.mock()
//        )
//
//        let permission = try await file.permission.patch(
//            detail.key,
//            File.Permission.Patch(
//                key: detail.key,
//                name: "name",
//                notes: "notes"
//            )
//        )
//        XCTAssertEqual(permission.key, detail.key)
//        XCTAssertEqual(permission.name, "name")
//        XCTAssertEqual(permission.notes, "notes")
//    }
//
//    func testDelete() async throws {
//        let detail = try await file.permission.create(
//            File.Permission.Create.mock()
//        )
//
//        try await file.permission.bulkDelete(
//            ids: [detail.key]
//        )
//
//        let permissions = try await file.permission.reference(
//            ids: [
//                detail.key
//            ]
//        )
//        XCTAssertTrue(permissions.isEmpty)
//    }
//}
