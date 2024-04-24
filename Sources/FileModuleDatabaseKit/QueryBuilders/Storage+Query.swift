//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

import FeatherDatabase
import FileModuleKit

extension File.Storage {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
