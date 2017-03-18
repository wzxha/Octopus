import Foundation
import CommandLineKit
import Rainbow
import OctopusKit

// Refer to onevat: https://github.com/onevcat/FengNiao/blob/master/Sources/FengNiao/main.swift

let cli = CommandLineKit.CommandLine()

let projectOption = StringOption(shortFlag: "p",
                                 longFlag: "project",
                                 helpMessage: "Path to the project what you want package")

let schemeOption = StringOption(shortFlag: "s",
                                longFlag: "scheme",
                                helpMessage: "Scheme to the project what you want package")

let configurationOption = MultiStringOption(shortFlag: "c",
                                            longFlag: "configuration",
                                            helpMessage: "Configuration to the project what you want package")

let bundleIdsOption = MultiStringOption(shortFlag: "b",
                                        longFlag: "bundleId",
                                        helpMessage: "Bundle ID to the project what you want package")

let help = BoolOption(shortFlag: "h",
                      longFlag: "help",
                      helpMessage: "Prints a help message.")

cli.addOptions(projectOption, schemeOption, bundleIdsOption, help)

cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.white
    default:
        str = s
    }
    
    return cli.defaultFormat(s: str, type: type)
}

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if help.value {
    cli.printUsage()
    exit(EX_OK)
}

let project = projectOption.value
let scheme = schemeOption.value
let configurations = configurationOption.value ?? []
let bundleIds = bundleIdsOption.value ?? [""]

let octopus = Octopus(project: project, scheme: scheme)

octopus.package(bundleIds: bundleIds, configurations: configurations)




