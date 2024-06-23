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
            url: "https://github.com/ilendemli/pulse-spm/releases/download/4.2.6/Pulse.xcframework.zip",
            checksum: "d231f2b7b06de3f445698656bc2662eca7328625888fdfc25b64050f52aedfa4"
        ),
        .binaryTarget(
            name: "PulseUI",
            url: "https://github.com/ilendemli/pulse-spm/releases/download/4.2.6/PulseUI.xcframework.zip",
            checksum: "6471dc983020bfd5e6e84e235b1b05b1b52a5d7f45fbd99dab664dfd3dbc3664"
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