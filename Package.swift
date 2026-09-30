// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AIStudio",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "AIStudio", targets: ["AIStudio"])
    ],
    targets: [
        .executableTarget(
            name: "AIStudio",
            path: "Sources/AIStudio"
        )
    ]
)
