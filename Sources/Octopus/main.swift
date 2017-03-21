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
import CommandLineKit
import Rainbow
import OctopusKit

// Refer to onevat: https://github.com/onevcat/FengNiao/blob/master/Sources/FengNiao/main.swift

let cli = CommandLineKit.CommandLine()

let projectOption =
    StringOption(shortFlag: "p",
    
                 longFlag: "project",
                 
                 helpMessage: "Path to the project that you want package")

let workspaceOption =
    StringOption(shortFlag: "w",
                 
                 longFlag: "workspace",
                 
                 helpMessage: "Path to the workspace that you want package")

let schemeOption = StringOption(shortFlag: "s",
                                longFlag: "scheme",
                                helpMessage: "Scheme to the project that you want package")

let configurationOption =
    MultiStringOption(shortFlag: "c",
                      
                      longFlag: "configuration",
                      
                      helpMessage: "Configuration to the project that you want package")

let bundleIdsOption =
    MultiStringOption(shortFlag: "b",
                      
                      longFlag: "bundleId",
                      
                      helpMessage: "Bundle ID to the project that you want package")

let bundleNameOption =
    MultiStringOption(shortFlag: "n",
                      
                      longFlag: "bundleName",
                      
                      helpMessage: "Bundle Name to the project that you want package")

let infoOption =
    StringOption(shortFlag: "i",
                 
                 longFlag: "info",
                 
                 helpMessage: "Info.plist's path to the project that you want package")

let help =
    BoolOption(shortFlag: "h",
               
               longFlag: "help",
               
               helpMessage: "Prints a help message.")

cli.addOptions(projectOption,
               workspaceOption,
               schemeOption,
               bundleIdsOption,
               bundleNameOption,
               configurationOption,
               infoOption,
               help)

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

let project = projectOption.value ?? ""
let workspace = workspaceOption.value ?? ""
let scheme = schemeOption.value ?? ""
let configurations = configurationOption.value ?? []
let bundleIds = bundleIdsOption.value ?? ["normal"]
let bundleNames = bundleNameOption.value ?? ["normal"]
let info = infoOption.value ?? ""

let octopus = Octopus(project: project, workspace: workspace, scheme: scheme, info: info)

octopus.package(bundleIds: bundleIds, bundleNames: bundleNames, configurations: configurations)




