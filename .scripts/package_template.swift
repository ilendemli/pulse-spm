// swift-tools-version:5.3

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
// GENERATED BINARY TARGETS
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
