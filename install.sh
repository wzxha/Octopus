#!/bin/sh

swift build --clean
swift test
swift build -c release
cp .build/release/Octopus /usr/local/bin/octopus
