//
//  Octopus.swift
//  Octopus
//
//  Created by WzxJiang on 17/3/18.
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
import PathKit

// An 🐙 that can be modified and packaged
public struct Octopus: Modify, Package {
    var project: String
    var scheme: String
    var info: String
    
    public init(project: String, workspace: String, scheme: String, info: String) {
        if project != "" {
            self.project = project
        } else if workspace != "" {
            self.project = workspace
        } else {
            self.project = Path.current.description + "/" + Path.current.lastComponent.description + ".xcodeproj"
        }
        
        if scheme != "" {
            self.scheme = scheme
        } else {
            self.scheme = Path(self.project).lastComponentWithoutExtension.description
        }
        
        self.info = info
        
        deleteLast()
    }
    
    public func package(bundleIds: [String], bundleNames: [String], configurations: [String]) {
        var originDictionary: NSDictionary = [:]
        
        for (index, bundleId) in bundleIds.enumerated() {
            
            guard bundleId == "normal" || info != "" else {
                log("If you want to change bundleID, you need give 🐙 a info.plist's path", type: .error)
                continue
            }
            
            var bundleName = "";
            
            if bundleNames.count > index {
                bundleName = bundleNames[index]
            }
            
            var configuration = "";
            
            if configurations.count > index {
                configuration = configurations[index]
            }
            
            originDictionary = modify(bundleId: bundleId, bundleName: bundleName)

            if configuration.lowercased() == "debug" {
                package(bundleId: bundleId, bundleName: bundleName, configuration: .debug)
            } else {
                package(bundleId: bundleId, bundleName: bundleName, configuration: .release)
            }
        }
        
        if originDictionary != [:] {
            restore(origin: originDictionary)
        }
        
        deleteArchive()
        
        log("God bless! YOU ARE SUCCEED!")
    }
}
