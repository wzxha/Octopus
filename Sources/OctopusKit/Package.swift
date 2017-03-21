//
//  Package.swift
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

public enum Configuration: String {
    case debug   = "Debug"
    case release = "Release"
}

private enum BuildAction: String {
    case clean         = "clean"
    case build         = "build"
    case archive       = "archive"
    case exportArchive = "-exportArchive"
}

internal protocol Package {
    var project: String { get }
    var scheme: String { get }
    
    func deleteLast()
    func deleteArchive()
    func package(bundleId: String, bundleName: String, configuration: Configuration)
}

internal extension Package {
    var path: String {
        var path: [String] = project.components(separatedBy: "/")
        path.removeLast()
        return path.joined(separator: "/")
    }
    
    var archivePath: String {
        return "\(path)/build/🔧🐙🔧/archive/\(scheme).xcarchive"
    }
    
    var exportPath: String {
        return "\(path)/build/🔧🐙🔧/"
    }
    
    func package(bundleId: String, bundleName: String, configuration: Configuration = .release) {
        log("package...project:\(project)...path:\(path)")
        
        guard project.hasSuffix(".xcodeproj") || project.hasSuffix(".xcworkspace") else {
            log("\(project) not a xcodeproj or xcworkspace", type: .error)
            log("exit...")
            return
        }
        
        if Path(project).isExecutable == false {
            log("\(project) not a file", type: .error)
            log("exit...")
            return
        }
        
        clean()
        archive(configuration: configuration)
        export(bundleId: bundleId, bundleName: bundleName, configuration: configuration)
    }
    
    func deleteLast() {
        log("delete last...")
        
        delete(path: Path("\(self.path)/build/🔧🐙🔧/"))
    }
    
    func deleteArchive() {
        log("delete archive...")
        
        delete(path: Path("\(self.path)/build/🔧🐙🔧/archive"))
    }
    
    private func delete(path: Path) {
        if path.isDirectory {
            
            log("delete...\(path.description)")
            
            try? path.delete()
        }
    }
    
    private func clean() {
        log("clean...")

        let shell = [BuildAction.clean.rawValue]
        
        try? run(shell)
    }
    
    private func archive(configuration: Configuration) {
        log("archive...\(archivePath)")

        let shell = [BuildAction.archive.rawValue,
                     "-scheme", scheme,
                     "-archivePath", archivePath,
                     "-configuration", configuration.rawValue]
        
        try? run(shell)
    }
    
    private func export(bundleId: String, bundleName: String, configuration: Configuration) {
        log("export...\(exportPath)")

        let shell = [BuildAction.exportArchive.rawValue,
                     "-archivePath", archivePath,
                     "-exportPath", exportPath + scheme.lowercased() + "_" + configuration.rawValue.lowercased() + "_\(bundleId)_\(bundleName).ipa",
                     "-exportFormat", "ipa"]
        
        try? run(shell)
    }
    
    private func run(_ args: [String], launchPath: String = "xcodebuild") throws -> Void {
        let task = Process()
        task.launchPath = "/usr/bin/" + launchPath
        task.currentDirectoryPath = path
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        
        guard task.terminationStatus == 0 else {
            log("\(args.first) error: \(task.terminationStatus)", type: .error)
            exit(0)
        }
    }
}
