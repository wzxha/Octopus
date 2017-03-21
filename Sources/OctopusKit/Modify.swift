//
//  Modify.swift
//  Octopus
//
//  Created by WzxJiang on 17/3/20.
//  Copyright © 2017 WzxJiang. All rights reserved.
//
//  https://github.com/Wzxhaha/Octopus
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import Foundation

internal enum PlistKey: String {
    case bundleId = "CFBundleIdentifier"
    case bundleName = "CFBundleName"
    case bundleShortVersion = "CFBundleShortVersionString"
}

internal protocol Modify {
    var info: String { get }
    
    func modify(bundleId: String, bundleName: String) -> NSDictionary
    
    func restore(origin: NSDictionary)
}

internal extension Modify {
    
    func modify(bundleId: String, bundleName: String) -> NSDictionary {
        if let originDictionary = read() {
            var writeDictionary = originDictionary
            write(&writeDictionary, key: .bundleId, value: bundleId)
            write(&writeDictionary, key: .bundleName, value: bundleName)
            save(writeDictionary)
            return originDictionary
        } else {
            log("Invalid info.plist path", type: .error)
            return [:]
        }
    }
    
    private func read() -> NSDictionary? {
        return NSDictionary(contentsOfFile: info)
    }
    
    private func write(_ dictionary: inout NSDictionary, key: PlistKey, value: String) {
        log("change info.plist: set \(key.rawValue)'s value to \(value)...")
        dictionary.setValue(value, forKey: key.rawValue)
    }
    
    private func save(_ dictionary: NSDictionary) {
        log("save info.plist")
        dictionary.write(toFile: info, atomically: true)
    }
    
    func restore(origin: NSDictionary) {
        log("restore info.plist")
        save(origin)
    }
}

