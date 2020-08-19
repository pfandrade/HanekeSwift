//
//  AsyncFetcher.swift
//  Haneke
//
//  Created by Hermes Pique on 1/2/16.
//  Copyright © 2016 Haneke. All rights reserved.
//

import Foundation
@testable import Haneke

class AsyncFetcher<T : DataConvertible&DataRepresentable> : Fetcher<T> where T.Result == T {

    let getValue : () -> T.Result

    init(key: String, value getValue : @autoclosure @escaping () -> T.Result) {
        self.getValue = getValue
        super.init(key: key)
    }

    open override func fetch(failure fail: @escaping ((Error?) -> ()), success succeed: @escaping (T.Result, @escaping  () -> Data) -> ()) {
        let value = getValue()
        let dataGenerator = { () -> Data in value.asData() }
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async {
                succeed(value, dataGenerator)
            }
        }
    }

    override func cancelFetch() {}

}
