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
  case Text
}


public enum NCBorderType {
  case LightCurved
}


public struct NCPoint {
  public var x: Int
  public var y: Int

  static let far = NCPoint(x: -10000, y: 0)
}


public struct TellSize {
  public var width = 0
  public var height = 0
  public var expandWidth = false
  public var expandMaxWidth = 0
  public var expandHeight = false
  public var expandMaxHeight = 0
  public var expandParentWidth = false
  public var expandParentHeight = false
  public var childrenWidth = 0
  public var childWidthExpander = 0
  public var childExpandMaxWidth = 0
  public var childrenHeight = 0
  public var childHeightExpander = 0
  public var childExpandMaxHeight = 0
  public var element: NCElement?
  public var children: [TellSize]?

  public var count = 0                 // Useful to record NCText's char count.
  public var borderTop = 0       // Store these for the drawing command.
  public var borderRight = 0
  public var borderBottom = 0
  public var borderLeft = 0
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
  var backgroundStrings: [String] { get set }


  func tellSize() -> TellSize

  func draw(x: Int, y: Int, size: TellSize)

  func drawBorder(x: Int, y: Int, size: TellSize) -> NCPoint

  func drawBackground(x: Int, y: Int, width: Int, height: Int,
      strings: [String])
}


extension NCElement {

  public func drawBorder(x: Int, y: Int, size: TellSize) -> NCPoint {
    let w = size.width
    let h = size.height
    if w <= 0 || h <= 0 {
      return NCPoint.far
    }
    var ny = y
    var nx = x
    var borderHeight = h
    if size.borderTop > 0 {
      var si = 0
      var ei = w
      if size.borderRight > 0 {
        move(Int32(ny), Int32(nx + w - 1))
        addstr("╮")
        ei -= 1
      }
      move(Int32(ny), Int32(nx))
      if size.borderLeft > 0 {
        addstr("╭")
        si += 1
      }
      if si < ei {
        for _ in si..<ei {
          addstr("─")
        }
      }
      ny += 1
      borderHeight -= 1
    }
    if size.borderBottom > 0 {
      borderHeight -= 1
      var si = 0
      var ei = w
      if size.borderRight > 0 {
        move(Int32(ny + borderHeight), Int32(nx + w - 1))
        addstr("╯")
        ei -= 1
      }
      move(Int32(ny + borderHeight), Int32(nx))
      if size.borderLeft > 0 {
        addstr("╰")
        si += 1
      }
      if si < ei {
        for _ in si..<ei {
          addstr("─")
        }
      }
    }
    if size.borderRight > 0 {
      let ei = ny + borderHeight
      let bx = nx + w - 1
      if ny < ei {
        for i in ny..<ei {
          move(Int32(i), Int32(bx))
          addstr("│")
        }
      }
    }
    if size.borderLeft > 0 {
      let ei = ny + borderHeight
      if ny < ei {
        for i in ny..<ei {
          move(Int32(i), Int32(nx))
          addstr("│")
        }
      }
      nx += 1
    }
    return NCPoint(x: nx, y: ny)
  }

  public func drawBackground(x: Int, y: Int, width: Int, height: Int,
      strings: [String]) {
    assert(width >= 0 && height >= 0)
    let blen = strings.count
    if blen == 0 || strings[0].isEmpty {
      return
    }
    let ey = y + height
    let ex = x + width
    let nx = Int32(x)
    if blen == 1 {
      let a = Array(strings[0].characters)
      let len = a.count
      let s = strings[0]
      if len == 1 {
        for i in y..<ey {
          move(Int32(i), nx)
          for _ in x..<ex {
            addstr(s)
          }
        }
      } else {
        let limit = ex - len + 1
        for i in y..<ey {
          move(Int32(i), nx)
          var j = x
          while j < limit {
            addstr(s)
            j += len
          }
          if j < ex {
            addstr(s.characters.substring(0, endIndex: ex - j))
          }
        }
      }
    } else {
      var si = 0
      let blen = strings.count
      for i in y..<ey {
        let s = strings[si]
        let slen = s.characters.count
        let limit = ex - slen + 1
        move(Int32(i), nx)
        var j = x
        while j < limit {
          addstr(s)
          j += slen
        }
        if j < ex {
          addstr(s.characters.substring(0, endIndex: ex - j))
        }
        si += 1
        if si >= blen {
          si = 0
        }
      }
    }
  }

}


public enum NCVerticalAlign {
  case Top
  case Center
  case Bottom
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
  public var backgroundStrings = [" "]
  public var align = NCTextAlign.Left
  public var verticalAlign = NCVerticalAlign.Center

  public init() { }

  public mutating func add(args: Any...) {
    addArgs(args)
  }

  public mutating func div(fn: (inout NCDiv) throws -> Void) throws {
    var d = NCDiv()
    try fn(&d)
    children.append(d)
  }

  public mutating func addArgs(args: [Any]) {
    for v in args {
      if v is String {
        var t = NCText()
        t.text = v as! String
        children.append(t)
      } else if v is NCText {
        children.append(v as! NCText)
      } else if v is NCSpan {
        children.append(v as! NCSpan)
      } else if v is NCDiv {
        children.append(v as! NCDiv)
      }
    }
  }

  public func tellSize() -> TellSize {
    var t = TellSize()
    t.element = self
    t.children = []
    for e in children {
      let s = e.tellSize()
      t.children!.append(s)
      t.childrenWidth += s.width
      if s.height > t.childrenHeight {
        t.childrenHeight = s.height
      }
      if s.expandWidth {
        t.childWidthExpander += 1
        if s.expandMaxWidth < 0 {
          t.childExpandMaxWidth = -1
        } else if t.childExpandMaxWidth >= 0 {
          t.childExpandMaxWidth += s.expandMaxWidth
        }
      }
      if s.expandHeight {
        t.childWidthExpander = 1
        if s.expandMaxHeight < 0 {
          t.childExpandMaxHeight = -1
        } else if t.childExpandMaxHeight >= 0 &&
            s.expandMaxHeight > t.childExpandMaxHeight {
          t.childExpandMaxHeight = s.expandMaxHeight
        }
      }
      if s.expandParentWidth {
        t.expandParentWidth = true
      }
      if s.expandParentHeight {
        t.expandParentHeight = true
      }
    }
    t.width = width
    if t.childrenWidth > t.width {
      t.width = t.childrenWidth
    }
    t.height = height
    if t.childrenHeight > t.height {
      t.height = t.childrenHeight
    }
    if t.width > 0 {
      if borderRight {
        t.borderRight = 1
        t.width += 1
      }
      if borderLeft {
        t.borderLeft = 1
        t.width += 1
      }
    }
    if maxWidth >= 0 && t.width > maxWidth {
      t.width = maxWidth
    }
    if t.height > 0 {
      if borderTop {
        t.borderTop = 1
        t.height += 1
      }
      if borderBottom {
        t.borderBottom = 1
        t.height += 1
      }
    }
    if maxHeight >= 0 && t.height > maxHeight {
      t.height = maxHeight
    }
    t.expandWidth = expandWidth
    t.expandHeight = expandHeight
    if expandParentWidth {
      t.expandParentWidth = true
      t.expandWidth = true
    }
    if expandParentHeight {
      t.expandParentHeight = true
      t.expandHeight = true
    }
    if t.expandWidth {
      t.expandMaxWidth = maxWidth
    }
    if t.expandHeight {
      t.expandMaxHeight = maxHeight
    }
    return t
  }

  public func draw(x: Int, y: Int, size: TellSize) {
    var w = size.width - size.borderLeft - size.borderRight
    let contentHeight = size.height - size.borderTop - size.borderBottom
    if w <= 0 || contentHeight <= 0 {
      return
    }
    var ap = drawBorder(x, y: y, size: size)
    var availableWidth = w - size.childrenWidth
    drawBackground(ap.x, y: ap.y, width: w, height: contentHeight,
        strings: backgroundStrings)

    ///////////////////////////// start /////////////////////////////////////
    // This code served as a template for NCDiv's height expanding.
    var childrenList = size.children!
    var widthExpander = size.childWidthExpander
    if widthExpander > 0 {
      var changedChildren = childrenList
      let len = changedChildren.count
      var expanders = [Bool](count: len, repeatedValue: false)
      for i in 0..<len {
        if childrenList[i].expandWidth {
          expanders[i] = true
        }
      }
      while availableWidth > 0 && widthExpander > 0 {
        var widthShare = availableWidth
        if widthExpander > 1 {
          widthShare = availableWidth / widthExpander
          if widthShare == 0 {
            widthShare = 1
          }
        }
        for i in 0..<len {
          let c = changedChildren[i]
          if expanders[i] {
            if c.expandMaxWidth == -1 {
              changedChildren[i].width += widthShare
              availableWidth -= widthShare
            } else if widthShare <= c.expandMaxWidth {
              changedChildren[i].width += widthShare
              changedChildren[i].expandMaxWidth -= widthShare
              availableWidth -= widthShare
            } else if c.expandMaxWidth == 0 {
              widthExpander -= 1
              expanders[i] = false
            }
            if availableWidth == 0 {
              break
            }
          }
        }
      }
      childrenList = changedChildren
      ///////////////////////////// end /////////////////////////////////////
    }

    if align != .Left && size.expandWidth && availableWidth > 0 {
      ap.x += align == .Right ? availableWidth : availableWidth / 2
    }

    for s in childrenList {
      var candidateSize = s
      if s.width > w {
        candidateSize.width = w
      }
      if verticalAlign != .Top && s.height < contentHeight {
        let yo = verticalAlign == .Center ? (contentHeight - s.height) / 2 :
            contentHeight - s.height
        s.element!.draw(ap.x, y: ap.y + yo, size: candidateSize)
      } else {
        s.element!.draw(ap.x, y: ap.y, size: candidateSize)
      }
      w -= s.width
      if w <= 0 {
        break
      }
      ap.x += s.width
    }
  }

}


public enum NCTextAlign {
  case Left
  case Center
  case Right
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
  public var align = NCTextAlign.Left
  public var backgroundStrings = [" "]

  public init() { }

  public func tellSize() -> TellSize {
    var t = TellSize()
    t.element = self
    t.count = text.characters.count
    if width > 0 {
      t.width = width
    } else {
      t.width = t.count
    }
    if t.width > 0 {
      if borderRight {
        t.borderRight = 1
        t.width += 1
      }
      if borderLeft {
        t.borderLeft = 1
        t.width += 1
      }
    }
    if maxWidth >= 0 && t.width > maxWidth {
      t.width = maxWidth
    }
    if height > 0 {
      t.height = height
    } else if t.count > 0 {
      t.height = 1
    }
    if t.height > 0 {
      if borderTop {
        t.borderTop = 1
        t.height += 1
      }
      if borderBottom {
        t.borderBottom = 1
        t.height += 1
      }
    }
    if maxHeight >= 0 && t.height > maxHeight {
      t.height = maxHeight
    }
    if expandWidth {
      t.expandWidth = true
      t.expandMaxWidth = maxWidth
    }
    if expandHeight {
      t.expandHeight = true
      t.expandMaxHeight = maxHeight
    }
    if expandParentWidth {
      t.expandParentWidth = true
    }
    if expandParentHeight {
      t.expandParentHeight = true
    }
    return t
  }

  public func draw(x: Int, y: Int, size: TellSize) {
    let ap = drawBorder(x, y: y, size: size)
    let w = size.width - size.borderLeft - size.borderRight
    if w > 0 {
      let contentHeight = size.height - size.borderTop - size.borderBottom
      drawBackground(ap.x, y: ap.y, width: w, height: contentHeight,
          strings: backgroundStrings)
      move(Int32(ap.y), Int32(ap.x))
      let len = size.count
      if w == len {
        addstr(text)
      } else {
        let z = String(text.characters.substring(0, endIndex: min(w, len)))
        if align != .Left {
          let n = align == .Right ? w - len : (w - len) / 2
          move(Int32(ap.y), Int32(ap.x + n))
        }
        addstr(z)
      }
    }
  }

}


public struct NCDiv: NCElement {
  public var type = NCType.Div
  public var children = [NCSpan]()

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
  public var backgroundStrings = [" "]


  public init() { }

  public mutating func span(args: Any...,
      fn: ((inout NCSpan) throws -> Void)? = nil) throws {
    var span = NCSpan()
    span.addArgs(args)
    if let af = fn {
      try af(&span)
    }
    children.append(span)
  }

  public func tellSize() -> TellSize {
    var t = TellSize()
    t.element = self
    t.children = []
    for e in children {
      let s = e.tellSize()
      t.children!.append(s)
      if s.width > t.childrenWidth {
        t.childrenWidth = s.width
      }
      t.childrenHeight += s.height
      if s.expandWidth {
        t.childWidthExpander = 1
        if s.expandMaxWidth < 0 {
          t.childExpandMaxWidth = -1
        } else if t.childExpandMaxWidth >= 0 &&
            s.expandMaxWidth > t.childExpandMaxWidth {
          t.childExpandMaxWidth = s.expandMaxWidth
        }
      }
      if s.expandHeight {
        t.childHeightExpander += 1
        if s.expandMaxHeight < 0 {
          t.childExpandMaxHeight = -1
        } else if t.childExpandMaxHeight >= 0 {
          t.childExpandMaxHeight += s.expandMaxHeight
        }
      }
      if s.expandParentWidth {
        t.expandParentWidth = true
      }
      if s.expandParentHeight {
        t.expandParentHeight = true
      }
    }
    t.width = width
    if t.childrenWidth > t.width {
      t.width = t.childrenWidth
    }
    t.height = height
    if t.childrenHeight > t.height {
      t.height = t.childrenHeight
    }
    if t.width > 0 {
      if borderRight {
        t.borderRight = 1
        t.width += 1
      }
      if borderLeft {
        t.borderLeft = 1
        t.width += 1
      }
    }
    if t.height > 0 {
      if borderTop {
        t.borderTop = 1
        t.height += 1
      }
      if borderBottom {
        t.borderBottom = 1
        t.height += 1
      }
    }
    t.expandWidth = expandWidth
    t.expandHeight = expandHeight
    if expandParentWidth {
      t.expandParentWidth = true
      t.expandWidth = true
    }
    if expandParentHeight {
      t.expandParentHeight = true
      t.expandHeight = true
    }
    if t.expandWidth {
      t.expandMaxWidth = maxWidth
    }
    if t.expandHeight {
      t.expandMaxHeight = maxHeight
    }
    return t
  }

  public func draw(x: Int, y: Int, size: TellSize) {
    NC.pd("div draw \(size.childrenWidth)")
    let w = size.width - size.borderLeft - size.borderRight
    var contentHeight = size.height - size.borderTop - size.borderBottom
    if w <= 0 || contentHeight <= 0 {
      return
    }
    var ap = drawBorder(x, y: y, size: size)
    drawBackground(ap.x, y: ap.y, width: w, height: contentHeight,
        strings: backgroundStrings)

    ///////////////////////////// start /////////////////////////////////////
    // This code is similar to NCSpan's width, except that it deals with height.
    var availableHeight = contentHeight - size.childrenHeight
    var childrenList = size.children!
    var heightExpander = size.childHeightExpander
    if heightExpander > 0 {
      var changedChildren = childrenList
      let len = changedChildren.count
      var expanders = [Bool](count: len, repeatedValue: false)
      for i in 0..<len {
        if childrenList[i].expandHeight {
          expanders[i] = true
        }
      }
      while availableHeight > 0 && heightExpander > 0 {
        var heightShare = availableHeight
        if heightExpander > 1 {
          heightShare = availableHeight / heightExpander
          if heightShare == 0 {
            heightShare = 1
          }
        }
        for i in 0..<len {
          let c = changedChildren[i]
          if expanders[i] {
            if c.expandMaxHeight == -1 {
              changedChildren[i].height += heightShare
              availableHeight -= heightShare
            } else if heightShare <= c.expandMaxHeight {
              changedChildren[i].height += heightShare
              changedChildren[i].expandMaxHeight -= heightShare
              availableHeight -= heightShare
            } else if c.expandMaxHeight == 0 {
              heightExpander -= 1
              expanders[i] = false
            }
            if availableHeight == 0 {
              break
            }
          }
        }
      }
      childrenList = changedChildren
    }
    /////////////////////////////  end  /////////////////////////////////////

    for s in childrenList {
      var candidateSize = s
      if s.height > contentHeight {
        candidateSize.height = contentHeight
      }
      if s.expandWidth || s.width > w {
        candidateSize.width = w
      }
      s.element!.draw(ap.x, y: ap.y, size: candidateSize)
      ap.y += s.height
      contentHeight -= s.height
      if contentHeight <= 0 {
        break
      }
    }
  }

  public func mainDraw(x: Int, y: Int, width: Int, height: Int) {
    var size = tellSize()
    if expandWidth {
      size.width = width
    }
    if expandHeight {
      size.height = height
    }
    draw(x, y: y, size: size)
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

  public func start(fn: (inout div: NCDiv) throws -> Void) throws {
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

    mainDiv.expandWidth = true
    mainDiv.expandHeight = true

    try fn(div: &mainDiv)

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
    mainDiv.mainDraw(0, y: 0, width: w, height: h)
    printLogs()
    refresh()
  }

}


public let NC = NCImpl()
