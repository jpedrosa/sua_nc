import PackageDescription

let package = Package(
  name:  "SuaNC",
  dependencies: [
    .Package(url: "../csua_module", majorVersion: 0),
    .Package(url:  "https://github.com/iachievedit/CNCURSES", majorVersion:1)
  ]
)
