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
            url: "https://github.com/ilendemli/pulse-spm/releases/download/4.2.2/Pulse.xcframework.zip",
            checksum: "6967ff6f0d0829a0b71f478a97844a0780e1eb282ee3f5a74e773fdfda4281c7"
        ),
        .binaryTarget(
            name: "PulseUI",
            url: "https://github.com/ilendemli/pulse-spm/releases/download/4.2.2/PulseUI.xcframework.zip",
            checksum: "5c250e535e48bc23399efb1004d3f8d2ac689cb6a250ad7c4d326a64cedfc0d7"
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