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
            url: "https://github.com/ilendemli/pulse-spm/releases/download/4.2.3/Pulse.xcframework.zip",
            checksum: "d3376253057db146a928a23c21e5d5cf321dad6155dd5a7b24a9be4fb50683af"
        ),
        .binaryTarget(
            name: "PulseUI",
            url: "https://github.com/ilendemli/pulse-spm/releases/download/4.2.3/PulseUI.xcframework.zip",
            checksum: "b21df996cfdaad8ac355a9acccb598e6152b665613766a265ef338b6eec5f472"
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