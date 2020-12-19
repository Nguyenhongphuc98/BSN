// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Server",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        //.package(url: "https://github.com/SwifQL/VaporBridges.git", from:"1.0.0-rc"),
        //.package(url: "https://github.com/SwifQL/PostgresBridge.git", from:"1.0.0-rc"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/apns", from: "1.0.0-rc"), // of Vapor, not suport certificate
        //.package(url:"https://github.com/matthijs2704/vapor-apns.git", from: "2.1.0") // was archived
        //.package(name: "apnswift", url: "https://github.com/kylebrowning/APNSwift.git", from: "2.1.0")
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
        //.package(url: "https://github.com/IBM-Swift/Swift-SMTP", from: "5.1.200"),
        //.package(url: "https://github.com/onevcat/Hedwig.git", from: "1.1.0"),
        //.package(url: "https://github.com/PerfectlySoft/Perfect-SMTP.git", from: "3.1.1"),
        //.package(url: "https://github.com/LiveUI/MailCore.git", from: "3.1.0"),
        //.package(url: "https://github.com/Kitura-Next/Swift-SMTP", from: "5.1.4"),
        .package(url: "https://github.com/Mikroservices/Smtp.git", from: "2.1.4")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
                //.product(name: "VaporBridges", package: "VaporBridges"),
                //.product(name: "PostgresBridge", package: "PostgresBridge")
                .product(name: "WebSocketKit", package: "websocket-kit"),
                .product(name: "APNS", package: "apns"),
                //.product(name: "VaporAPNS", package: "vapor-apns"),
                //.product(name: "APNSwift", package: "apnswift"),
                .product(name: "SwiftyJSON", package: "SwiftyJSON"),
                //.product(name: "SwiftSMTP", package: "Swift-SMTP"),
                //.product(name: "PerfectSMTP", package: "Perfect-SMTP"),
                //.product(name: "MailCore", package: "MailCore"),
                //.product(name: "SwiftSMTP", package: "Swift-SMTP"),
                .product(name: "Smtp", package: "Smtp")
                
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
