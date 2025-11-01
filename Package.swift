// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-sam-vapor-sample",
  platforms: [.macOS(.v26)],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
  ],
  targets: [
    .executableTarget(
      name: "App",
      dependencies: [
        .product(name: "Vapor", package: "vapor")
      ],
      swiftSettings: swiftSettings,
    ),
    .testTarget(
      name: "AppTests",
      dependencies: [
        .product(name: "VaporTesting", package: "vapor"),
        .target(name: "App"),
      ],
      swiftSettings: swiftSettings,
    ),
  ],
  swiftLanguageModes: [.v6],
)
var swiftSettings: [SwiftSetting] {
  [
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("NonescapableTypes"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("InternalImportsByDefault"),
  ]
}
