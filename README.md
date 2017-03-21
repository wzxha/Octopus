# Octopus 🐙
A command tool to package multiple projects <br/>
Support:
- multi-BundleID
- multi-BundleName
- multi-Configuration

## Use
1. `swift package update`
2. `swift build`
3. `./.build/debug/Octopus -h`

## Help
```shell
Usage: ./.build/debug/Octopus [options]
  -p, --project:
      Path to the project that you want package
  -w, --workspace:
      Path to the workspace that you want package
  -s, --scheme:
      Scheme to the project that you want package
  -b, --bundleId:
      Bundle ID to the project that you want package
  -n, --bundleName:
      Bundle Name to the project that you want package
  -c, --configuration:
      Configuration to the project that you want package
  -i, --info:
      Info.plist's path to the project that you want package
  -h, --help:
      Prints a help message.
```

## TODO
1. ~~support multiple bundleID~~
2. ~~support multiple displayName~~
3. Code Coverage 100%
4. more..

## If you want a xcodeproj
`swift package generate-xcodeproj`

## License
Octopus is released under the MIT license. See LICENSE for details.
