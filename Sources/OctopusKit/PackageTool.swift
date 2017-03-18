import Foundation
import PathKit

enum BuildActions: String {
    case clean = "clean"
    case build = "build"
    case archive = "archive"
}

enum Configuration: String {
    case debug = "debug"
    case release = "release"
}

struct PackageTool {
    var project: String
    var scheme: String
    var midArguments: [String]
    
    // 暂时不开放
    let archivePath: Path
    let exportPath: Path

    init(project: String?, scheme: String?) {
        self.midArguments = []
        
        if let proj = project {
            self.midArguments += ["-project"] + ["\(proj)/\(Path(proj).lastComponent).xcodeproj"]
            self.project = proj
        } else {
            self.project = Path.current.description
        }
        
        if let sch = scheme {
            self.scheme = sch
        } else {
            self.scheme = Path(self.project).lastComponentWithoutExtension.description
        }
        
        self.archivePath = Path("\(self.project)/build/🐙/archive/\(self.scheme).xcarchive")
        self.exportPath = Path("\(self.project)/build/🐙/\(self.scheme).ipa")
    }
    
    public func package(bundleId: String?, configuration: String?) -> Void {
        clean(bundleId: bundleId, configuration: configuration)
        archive(bundleId: bundleId, configuration: configuration)
        export(bundleId: bundleId, configuration: configuration)
    }
    
    public func clean(bundleId: String?, configuration: String?) -> Void {
        try! FileManager.default.removeItem(atPath: "\(self.project)/build/🐙")
        
        let shell = xcodebuildShell(action: .clean,
                                    bundleId: bundleId,
                                    configuration: configuration)
        let status = try? self.run(shell: shell)
        print(status ?? "没有值啊")
    }
    
    public func archive(bundleId: String?, configuration: String?) -> Void {
        var shell = xcodebuildShell(action: .archive,
                                    bundleId: bundleId,
                                    configuration: configuration)
        
        shell += ["-scheme"] + [self.scheme]
    
        shell += ["-archivePath"] + [self.archivePath.description]
        
        let status = try? self.run(shell: shell)
        print(status ?? "没有值啊")
    }
    
    public func export(bundleId: String?, configuration: String?) -> Void {
        var shell = xcodebuildShell(bundleId: bundleId,
                                    configuration: configuration)
        
        shell += ["-exportArchive"]
        
        shell += ["-archivePath"] + [self.archivePath.description]
        
        shell += ["-exportPath"] + [self.exportPath.description]
        
        shell += ["-exportFormat"] + ["ipa"]
        
        let status = try? self.run(shell: shell)
        print(status ?? "没有值啊")
    }
    
    internal func xcodebuildShell(action: BuildActions = .build, bundleId: String?, configuration: String?) -> [String] {
        var arguments = [String]()
        if action != .build {
            arguments += [action.rawValue]
        }
        arguments += self.midArguments
        
        if let configuration = configuration {
            if configuration.lowercased() == Configuration.debug.rawValue {
                arguments += ["-configuration"] + ["Debug"]
            } else if configuration.lowercased() == Configuration.release.rawValue {
                arguments += ["-configuration"] + ["Release"]
            }
        }
        
        return arguments
    }
    
    @discardableResult
    private func run(shell args: [String], launchPath: String = "xcodebuild") throws -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/" + launchPath
        task.arguments = args
//        print("LOG: \(task.arguments)")
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}
