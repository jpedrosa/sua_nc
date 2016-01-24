import Glibc
import CSua
import CNC


func ncIntSignalHandler(n: Int32) {
  endwin()
  exit(0)
}


func ncWinchSignalHandler(n: Int32) {
  endwin()
  refresh()
  initscr()
  clear()
  NC.drawAgain()
}


public enum NCType {
  case Div
  case Span
  case Row
  case Text
}


public enum NCBorderType {
  case LightCurved
}


public struct TellSize {
  public var width = 0
  public var height = 0
  public var expandWidth = 0
  public var expandHeight = 0
  public var expandParentWidth = 0
  public var expandParentHeight = 0
  public var expandWidthFreely = 0
  public var expandHeightFreely = 0
}


public protocol NCElement {
  var type: NCType { get }
  var maxWidth: Int { get set }
  var maxHeight: Int { get set }
  var width: Int { get set }
  var height: Int { get set }
  var borderTop: Bool { get set }
  var borderRight: Bool { get set }
  var borderBottom: Bool { get set }
  var borderLeft: Bool { get set }
  var borderType: NCBorderType { get set }
  var expandWidth: Bool { get set }
  var expandHeight: Bool { get set }
  var expandParentWidth: Bool { get set }
  var expandParentHeight: Bool { get set }

  mutating func tellSize() -> TellSize

  func draw(x: Int, y: Int, width: Int, height: Int)
}


public struct NCRow: NCElement {
  public var type = NCType.Row
  public var children = [NCElement]()

  public var maxWidth = -1
  public var maxHeight = -1
  public var width = -1
  public var height = -1
  public var borderTop = false
  public var borderRight = false
  public var borderBottom = false
  public var borderLeft = false
  public var borderType = NCBorderType.LightCurved
  public var expandWidth = true
  public var expandHeight = false
  public var expandParentWidth = true
  public var expandParentHeight = false

  public init() { }

  public mutating func tellSize() -> TellSize {
    var t = TellSize()
    for e in children {
      var me = e
      let s = me.tellSize()
      t.width += s.width
      if s.height > t.height {
        t.height = s.height
      }
      t.expandWidth += s.expandWidth
      if s.expandWidthFreely > 0 {
        t.expandWidthFreely += 1
      }
      if s.expandHeight > 0 {
        t.expandHeight = 1
        if s.expandHeightFreely > 0 {
          t.expandHeightFreely += 1
        }
      }
      t.expandParentWidth += s.expandParentWidth
      if s.expandParentHeight > 0 {
        t.expandParentHeight = 1
      }
    }
    return t
  }

  public func draw(x: Int, y: Int, width: Int, height: Int) {

  }

}


public struct NCSpan: NCElement {
  public var type = NCType.Span
  public var children = [NCElement]()

  public var maxWidth = -1
  public var maxHeight = -1
  public var width = -1
  public var height = -1
  public var borderTop = false
  public var borderRight = false
  public var borderBottom = false
  public var borderLeft = false
  public var borderType = NCBorderType.LightCurved
  public var expandWidth = false
  public var expandHeight = false
  public var expandParentWidth = false
  public var expandParentHeight = false

  public init() { }

  public mutating func tellSize() -> TellSize {
    var t = TellSize()
    for e in children {
      var me = e
      let s = me.tellSize()
      t.width += s.width
      if s.height > t.height {
        t.height = s.height
      }
      if s.expandWidth > 0 {
        t.expandWidth += 1
        if s.expandWidthFreely > 0 {
          t.expandWidthFreely += 1
        }
      }
      if s.expandHeight > 0 {
        t.expandHeight = 1
        if s.expandHeightFreely > 0 {
          t.expandHeightFreely = 1
        }
      }
      t.expandParentWidth += s.expandParentWidth
      t.expandParentHeight += s.expandParentHeight
    }
    return t
  }

  public func draw(x: Int, y: Int, width: Int, height: Int) {

  }

}


public struct NCText: NCElement {
  public var type = NCType.Text
  public var text = ""

  public var maxWidth = -1
  public var maxHeight = -1
  public var width = -1
  public var height = -1
  public var borderTop = false
  public var borderRight = false
  public var borderBottom = false
  public var borderLeft = false
  public var borderType = NCBorderType.LightCurved
  public var expandWidth = false
  public var expandHeight = false
  public var expandParentWidth = false
  public var expandParentHeight = false
  public var count = 0

  public init() { }

  public mutating func tellSize() -> TellSize {
    var t = TellSize()
    count = text.characters.count
    if width > 0 {
      t.width = width
    } else {
      t.width = count
    }
    if height > 0 {
      t.height = height
    } else if count > 0 {
      t.height = 1
    }
    if expandWidth {
      t.expandWidth = 1
      if width == -1 && maxWidth == -1 {
        t.expandWidthFreely = 1
      }
    }
    if expandHeight {
      t.expandHeight = 1
      if height == -1 && maxHeight == -1 {
        t.expandHeightFreely = 1
      }
    }
    if expandParentWidth {
      t.expandParentWidth = 1
    }
    if expandParentHeight {
      t.expandParentHeight = 1
    }
    return t
  }

  public func draw(x: Int, y: Int, width: Int, height: Int) {

  }

}


public struct NCDiv: NCElement {
  public var type = NCType.Div
  public var children = [NCRow]()

  public var maxWidth = -1
  public var maxHeight = -1
  public var width = -1
  public var height = -1
  public var borderTop = false
  public var borderRight = false
  public var borderBottom = false
  public var borderLeft = false
  public var borderType = NCBorderType.LightCurved
  public var expandWidth = true
  public var expandHeight = false
  public var expandParentWidth = true
  public var expandParentHeight = false

  public init() { }

  public mutating func div(args: Any...) -> NCRow {
    var r = NCRow()
    for v in args {
      if v is String {
        var t = NCText()
        t.text = v as! String
        r.children.append(t)
        NC.pd("String \(v)")
      }
    }
    children.append(r)
    return r
  }

  public func tellSize() -> TellSize {
    var t = TellSize()
    for e in children {
      var me = e
      let s = me.tellSize()
      if s.width > t.width {
        t.width = s.width
      }
      t.height += s.height
      if s.expandWidth > 0 {
        t.expandWidth = 1
        if s.expandWidthFreely > 0 {
          t.expandWidthFreely = 1
        }
      }
      if s.expandHeight > 0 {
        t.expandHeight += 1
        if s.expandHeightFreely > 0 {
          t.expandHeightFreely += 1
        }
      }
      if s.expandParentWidth > 0 {
        t.expandParentWidth = 1
      }
      if s.expandParentHeight > 0 {
        t.expandParentHeight += 1
      }
    }
    return t
  }

  public func draw(x: Int, y: Int, width: Int, height: Int) {
    var ny = y
    for r in children {
      var mr = r
      NC.pd(inspect(mr.tellSize()))
      //r.draw()
    }
  }

}


public class NCImpl {

  public let NORMAL    = Int32(0)
  public let STANDOUT  = Int32(65536)
  public let UNDERLINE = Int32(131072)           // A_UNDERLINE
  public let REVERSE   = Int32(262144)
  public let BOLD      = Int32(2097152)               // A_BOLD
  public let INVIS     = Int32(8388608)
  public let BUTTON1_CLICKED = UInt(4)

  public var debugy = Int32(2)
  public var _log = [String]()

  public func pd(s: String) {
    _log.append(s)
  }

  public func printLogs() {
    let len = _log.count
    let si = max(len - 10, 0)
    var j = 0
    for i in si..<len {
      move(debugy + j, 80)
      addstr(_log[i])
      j += 1
    }
  }

  public func exitWithError() {
    endwin()
    exit(1)
  }

  public func handleMouseClick() {
    pd("mouse click \(KEY_MOUSE)")
  }

  var invalidated = false
  var mainDiv = NCDiv()

  public func start(fn: (inout div: NCDiv) -> Void) {
    Signal.trap(Signal.INT, ncIntSignalHandler)
    Signal.trap(SIGWINCH, ncWinchSignalHandler)

    setlocale(LC_ALL, "")

    initscr()
    start_color()
    noecho()
    curs_set(0)
    keypad(stdscr, true)
    mousemask(NC.BUTTON1_CLICKED, nil)
    init_pair(8, Int16(COLOR_WHITE), Int16(COLOR_BLUE))

    assume_default_colors(-1, -1)

    mainDiv.expandHeight = true

    fn(div: &mainDiv)

    timeout(0)

    while true {
      move(2, 2)
      drawAgain()
      while !invalidated {
        var c = getch()
        if c != -1 {
          if c == KEY_MOUSE {
            handleMouseClick()
            break
          }
          var a: [Int32] = []
          while c != -1 {
            a.append(c)
            c = getch()
          }
          // pd("\(inspect(a))")
          break
        }
        IO.sleep(0.1)
      }
    }
  }

  public func drawAgain() {
    clear()
    let w = Int(getmaxx(stdscr))
    let h = Int(getmaxy(stdscr))
    mainDiv.draw(0, y: 0, width: w, height: h)
    printLogs()
    refresh()
  }

}


public let NC = NCImpl()
