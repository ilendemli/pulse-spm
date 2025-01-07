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
        .binaryTarget(
            name: "Pulse",
            url: "https://github.com/ilendemli/pulse-spm/releases/download/5.1.1/Pulse.xcframework.zip",
            checksum: "e4e0b391a2fa1a060f20b639f05fcfc120405364f39b4058dbb2043a60027fd4"
        ),
        .binaryTarget(
            name: "PulseUI",
            url: "https://github.com/ilendemli/pulse-spm/releases/download/5.1.1/PulseUI.xcframework.zip",
            checksum: "9d71079cd12bcadedd5603c54d8eb305515951727e7c4ab8c2933c427c311009"
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