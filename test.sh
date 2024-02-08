#!/usr/bin/env bash
TARGET=NowPlayingFormatter

xcodebuild -scheme ${TARGET} test -sdk iphonesimulator -destination 'platform=iOS Simulator,OS=latest,name=iPhone 15'
