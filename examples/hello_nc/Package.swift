import PackageDescription

let package = Package(
  name:  "HelloNC",
  dependencies: [
    .Package(url: "../../", majorVersion: 0)
  ]
)
