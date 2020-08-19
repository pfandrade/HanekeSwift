//
//  Fetcher.swift
//  Haneke
//
//  Created by Hermes Pique on 9/9/14.
//  Copyright (c) 2014 Haneke. All rights reserved.
//

import UIKit

// See: http://stackoverflow.com/questions/25915306/generic-closure-in-protocol
open class Fetcher<T : DataConvertible> {

    public let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    open func fetch(failure fail: @escaping ((Error?) -> ()), success succeed: @escaping (T.Result, @escaping () -> Data) -> ()) {}
    
    open func cancelFetch() {}
}

class SimpleFetcher<T : DataConvertible&DataRepresentable> : Fetcher<T> where T.Result == T {
    
    let getValue : () -> T
    
    init(key: String, value getValue : @autoclosure @escaping () -> T) {
        self.getValue = getValue
        super.init(key: key)
    }
    
    override func fetch(failure fail: @escaping ((Error?) -> ()), success succeed: @escaping (T.Result, @escaping () -> Data) -> ()) {
        let value = getValue()
        let dataGenerator = { () -> Data in value.asData() }
        succeed(value, dataGenerator)
    }
    
    override func cancelFetch() {}
    
}
