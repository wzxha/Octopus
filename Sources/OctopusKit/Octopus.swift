import Foundation

public struct Octopus {
    let packageTool: PackageTool
    
    public init(project: String?, scheme: String?) {
        self.packageTool = PackageTool(project: project, scheme: scheme)
    }
    
    public func package(bundleIds: [String], configurations: [String]) -> Void {
        for (index, bundleId) in bundleIds.enumerated() {
            var configuration = "";
            
            if configurations.count > index {
                configuration = configurations[index]
            }
            
            packageTool.package(bundleId: bundleId, configuration: configuration)
        }
    }
}
