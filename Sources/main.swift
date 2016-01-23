
import Glibc
import CSua


print(try File.expandPath("~/t_"))          // Prints /home/dewd/t_
// The following prints: /home/dewd/t_/swift
print(try File.expandPath(File.join("~/t_", s: "swift")))
print(File.extName("some.png"))            // Prints .png
print(File.baseName("../t_/some.png"))     // Prints some.png



// p(try File.expandPath("~/**/"))
//
// p(try File.expandPath("/"))
//
// p(try File.expandPath("////a///b"))

// var stream = ByteStream(bytes: "hello".bytes)
// p(stream.matchStringFromListAtEnd(["list", "ello"]))
// var list = ["maxhello", "o", "behold", "llo"].map { $0.bytes }
// p(stream.eatBytesFromListAtEnd(list))
// p(stream.matchBytesFromListAtEnd(list))


// var counter = 0
// var list = try FileGlobList(pattern: "/home/dewd/t_/**/") { name, type, path in
//var list = try FileGlobList(pattern: "/home/dewd/**/*") { name, type, path in
//var list = try FileGlobList(pattern: "/home/dewd/**/grapes.txt") { name, type, path in
//var list = try FileGlobList(pattern: "/home/dewd/**/*.txt") { name, type, path in
// var list = try FileGlobList(pattern: "/home/dewd/**/s*.txt") { name, type, path in
//var list = try FileGlobList(pattern: "s*.txt") { name, type, path in
//var list = try FileGlobList(pattern: "/home/dewd/**/t_/s*/*") { name, type, path in
//var list = try FileGlobList(pattern: "/home/dewd/t_/s*/*") { name, type, path in
// var list = try FileGlobList(pattern: "/home/dewd/t_/s*/*", skipDotFiles: false,
//     ignoreCase: true) { name, type, path in
// var list = try FileGlobList(pattern: "/home/dewd/t_/s*/*", skipDotFiles: false,
//     ignoreCase: true) { name, type, path in
//var list = try FileGlobList(pattern: "*") { name, type, path in
// var list = try FileGlobList(pattern: "/home/**/dewd/**/t_") { name, type, path in
// var list = try FileGlobList(pattern: "/home/dewd/**/d*/*.txt") { name, type, path in
  // counter += 1
  // print("\(path)\(name)")
//  print("\(type):\(path)\(name)")
// }

// try list.list()

// p("counter \(counter)")

//for e in Dir["/home/dewd/t_/**/"] {
// for e in Dir["/home/dewd/t_/**/*.txt"] {
//for (name, type, path) in Dir["/home/dewd/*"] {
//for (name, type, path) in Dir["/home/dewd/t_/todo_list.txt"] {
//for (name, type, path) in Dir["/home/dewd/t_/"] {
// for (name, type, path) in Dir[try File.expandPath("~/t_/*")] {
// for (name, type, path) in Dir["/home/dewd/t_/*"] {
//for (name, type, path) in Dir["/home/dewd/**/*{.png,.jpg}"] {
//for (name, type, path) in Dir["/home/dewd/t_/**/*.txt"] {
  // print("\(type):\(path)\(name)")
// }


// try Dir.glob("/home/dewd/t_/**/*.swift") { name, type, path in
//   p(name)
// }

// p(try Dir.globList("/home/dewd/t_/**/*.swift"))

// var sw = Stopwatch()
// var counter = 0
// sw.start()
// FileBrowser.recurseDir("/home/") { name, type, path in
//   counter += 1
// }
// p("counter \(counter) elapsed: \(sw.millis)")

// try Dir.glob("../../*") { print($0.0) }
//
// for m in Dir["../../*"] { print(m.0) }

//try list.recurseAndAddDirectories("/home/dewd/t_/")
//p("=======")
// try list.recurseAndMatch("/home/dewd/t_/", partIndex: 7)


// p(try GlobMatcher.parse("hello"))
//
// p(try GlobMatcher.parse("hello?world"))

// p(try GlobMatcher.parse("hello?w[o]rld"))

// var bm = try GlobMatcher.parse("hello*.txt").assembleMatcher()
// p(bm.match("hello_world.txta")) // Prints 15.

// If instead we call the matchEos on the ByteMatcher:
// var bm2 = try GlobMatcher.parse("hello*.txt").assembleMatcher()
// bm2.matchEos()
// p(bm2.match("hello_world.txta")) // Prints -1. Not found. Since it didn't

// var gm = try GlobMatcher.parse("HELLO*.txt")
// gm.ignoreCase = true
// var bm = gm.assembleMatcher()
// p(bm.match("hello_world.txta")) // Prints 15.

// var g = try Glob.parse("HELLO*.txt", ignoreCase: true)
// p(g.match("hello_world.txt.andmore.txt")) // Prints true

// var g = try Glob.parse("hello*.txt")
// print(g.match("hello_world.txt")) // Prints true.

var g = try Glob.parse("hello*{.txt,.jpg,.png}")
print(g.match("hello_world.txt")) // Prints true.
print(g.match("hello.png")) // Prints true.
print(g.match("hello_there.jpg")) // Prints true.
print(g.match("hello_there.jpg")) // Prints true.

// print(try File.expandPath("~/t_"))          // Prints /home/dewd/t_
// The following prints: /home/dewd/t_/swift
// print(try File.expandPath(File.join("~/t_", secondPath: "swift")))
// print(File.extName("some.png"))            // Prints .png
// print(File.baseName("../t_/some.png"))     // Prints some.png

//var g = try Glob.parse("h*l?o*{.image,.txt}", ignoreCase: true)
// var g = try Glob.parse("h*l?o*{.IMAGE,.txt}", ignoreCase: true)
// p(g.match("hello_world.txt.andmore.txt")) // Prints true
// p(g.match("hello_world.txt.andmore.txt.image")) // Prints true
// p(g.match("hello_world.txt.andmore.txt.image")) // Prints true
// p(g.match("hello_world.txt.DHUHASDUH.txt.IMAGE")) // Prints true

// var g = try Glob.parse("*.txt", ignoreCase: true)
// p(g.match("hello_world.txt")) // Prints true
// p(g.match("yello.txt.txt")) // Prints true
// p(g.match("green.png")) // Prints true

// var a: [[UInt8]] = [[97, 99, 101, 103, 105], [65, 67, 107, 109], [69]]
// p(Ascii.toLowerCase(a))
//
// p(Ascii.toLowerCase("Hello"))

// p(try GlobMatcher.parse("hello?w[o]rld*.txt"))

// var fm = try GlobMatcher.parse("hello*.txt").assembleMatcher()
//fm.matchEos()
// p(fm.match("hello_world.txta"))


// var m = GlobMatcher()
//m.addName("hey".bytes)
//m.addAny()
// m.addName("let".bytes)
// m.addAny()
// m.addName("go".bytes)
// m.addOne()
// m.addOne()
// m.addOne()
// m.addOne()
// m.startSet()
// m.addSetRange(97, c2: 122)
// m.negateSet()
// m.saveSet()
// m.addSetChar(65)
// m.addSetChar(66)
// m.addSetRange(65, c2: 90)
// m.negateSet()
// m.startAlternative()
// m.addAlternativeName(".jpg".bytes)
// m.addAlternativeName(".png".bytes)
// m.saveAlternative()
// p(m)
// var tm = m.assembleMatcher()
// p(tm)
// p(tm.match("hey ho let's go and away we go!"))
// p(tm.match("hey.jpg"))
// p(tm.match("hey.png"))
// p(tm.match("hey you  .jpg"))
// p(tm.match("hey you  .png"))



// var someBytes: [UInt8] = [97, 99, 101]
// p(someBytes)
// p(Ascii.toLowerCase(someBytes))


// p(tolower(100))
//
// func genSample5() -> String { return "/more[az-de].c" }
//
// func genSample6() -> String { return "more[a-Z].c" }
//
// func genSample7() -> String { return "more[-a-zA-Z0-9_].c" }
//
// func genSample8() -> String { return "more[^a-z].c" }
//
// func genSample9() -> String { return "more\\[^a-z].c" }
//
// func genSample10() -> String { return "\\more\\[^a-z].c" }
//
// func genSample11() -> String { return "more[\\^a-z].c" }
//
// func genSample12() -> String { return "more[^a-z\\]].c" }
//
// func genSample13() -> String { return "more[^\\a-z].c" }
//
// func genSample14() -> String { return "more{sayo\\,nara}.c" }
//
// func genSample15() -> String { return "more{sayo,nara\\}.c" }
//
// func genSample16() -> String { return "more[a-z]\\*.c" }
//
// func genSample17() -> String { return "more{,error}.c" }
//
// func genSample18() -> String { return "more{hello,world}.c" }
//
// var lexer = GlobLexer(bytes: genSample8().bytes)
//
// try lexer.parseTokenStrings() { tt, s in
//   print("\(tt) - \(inspect(s))")
//  print((tt as! FileGlobTokenType).rawValue)
// }

//p(try lexer.parseAllTokens())
