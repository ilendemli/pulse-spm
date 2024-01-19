// swift-tools-version:5.3

// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import PackageDescription

let package = Package(
    name: "pulse-spm",
    defaultLocalization: "en",
    products: [
        .library(
            name: "Pulse",
            targets: [
                "PulseTarget"
            ]
        ),
        .library(
            name: "PulseUI",
            targets: [
                "PulseUITarget"
            ]
        )
    ],
    targets: [
        .binaryTarget(
            name: "Pulse",
            url: "https://github.com/ilendemli/pulse-spm/releases/download/4.0.5/Pulse.xcframework.zip",
            checksum: "0cd933aa52dd7796c7aa6626c9418fc93431637843e1590a024d6310b5c7e788"
        ),
        .binaryTarget(
            name: "PulseUI",
            url: "https://github.com/ilendemli/pulse-spm/releases/download/4.0.5/PulseUI.xcframework.zip",
            checksum: "4bf1d5570fb74d92127e4f1e92e5956647f694168cef68048249ea2c97f8fc0e"
        ),
        .target(
            name: "PulseTarget",
            dependencies: [
                "Pulse"
            ],
            path: "Pulse",
            sources: [
                "Empty.m"
            ]
        ),
        .target(
            name: "PulseUITarget",
            dependencies: [
                "Pulse",
                "PulseUI"
            ],
            path: "PulseUI",
            sources: [
                "Empty.m"
            ]
        )
    ]
)