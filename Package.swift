// swift-tools-version: 5.9
// Swift Package manifest for the fully-offline "FormaVoice" workspace.
// Using Swift 6 toolchain to enable strict concurrency and upcoming language features. :contentReference[oaicite:0]{index=0}

import PackageDescription

let package = Package(
    name: "FormaVoice",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17) // iOS 17 ensures Metal-based GGUF inference and latest SwiftData APIs. :contentReference[oaicite:1]{index=1}
    ],
    products: [
        .library(
            name: "FormaVoiceCore",
            targets: ["FormaVoiceCore"]
        ),
        // The executable target itself builds an iOS app; Xcode will generate
        // the runnable scheme.  The dedicated iOSApplication product type is
        // still behind a future SwiftPM release, so we omit it to keep the
        // manifest compatible with Xcode 16.4's toolchain.
    ],
    dependencies: [
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0")
    ],
    targets: [
        .target(
            name: "FormaVoiceCore",
            dependencies: [
                "ZIPFoundation",
                "llama_cpp",
                "whisper_cpp"
            ],
            path: "Sources",
            exclude: ["Vendor"],
            resources: [
                // Copy rather than process to avoid compression and keep file size unchanged.
                .copy("Resources/Models")
            ],
            publicHeadersPath: "Bridges",
            cxxSettings: [
                .headerSearchPath("../Vendor/llama.cpp/include"),
                .headerSearchPath("../Vendor/whisper.cpp/include")
            ],
            swiftSettings: [
                .unsafeFlags(["-enable-upcoming-feature", "StrictConcurrency"]) // Compile-time data-race diagnostics. :contentReference[oaicite:2]{index=2}
            ],
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("Metal"),
                .linkedFramework("PDFKit"),
                .linkedFramework("SwiftData"),
                
            ]
        ),
        .target(
            name: "llama_cpp",
            path: "Vendor/llama.cpp",
            exclude: [
                "examples", "docs", "media", "scripts", "tests", "models", "gguf-py", "bindings", ".github", ".git", "requirements", "Makefile", "CMakeLists.txt"
            ],
            publicHeadersPath: "include",
            cxxSettings: [
                .define("GGML_METAL"),
                .unsafeFlags(["-std=c++17", "-Wno-everything"])
            ],
            linkerSettings: [
                .linkedFramework("Metal"),
                .linkedFramework("Accelerate")
            ],
            sources: ["src", "ggml/src", "ggml/quants"]
        ),
        .target(
            name: "whisper_cpp",
            path: "Vendor/whisper.cpp",
            exclude: [
                "examples", "tests", "models", "samples", "scripts", "bindings", "ci", "cmake", "Makefile", "CMakeLists.txt", "docs", ".github", ".git"
            ],
            publicHeadersPath: "include",
            cxxSettings: [
                .define("GGML_METAL"),
                .unsafeFlags(["-std=c++17", "-Wno-everything"])
            ],
            linkerSettings: [
                .linkedFramework("Metal"),
                .linkedFramework("Accelerate")
            ],
            sources: ["src"]
        ),
        .executableTarget(
            name: "FormaVoiceApp",
            dependencies: ["FormaVoiceCore", "llama_cpp", "whisper_cpp"],
            path: "AppExecutable",
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "AppExecutable/Info.plist"
                ])
            ]
        ),
        .testTarget(
            name: "FormaVoiceUITests",
            dependencies: ["FormaVoiceCore"],
            path: "UITests"
        ),
        .testTarget(
            name: "FormaVoiceTests",
            dependencies: ["FormaVoiceCore"],
            path: "Tests"
        )
    ]
)