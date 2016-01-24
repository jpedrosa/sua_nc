

import Glibc
import CSua
import CNC
import SuaNC


let NC_BOLD = Int32(2097152)               // A_BOLD
let NC_UNDERLINE = Int32(131072)           // A_UNDERLINE
let NC_BUTTON1_CLICKED = UInt(4)
let NC_STANDOUT = Int32(65536)
let NC_NORMAL = Int32(0)
let NC_REVERSE = Int32(262144)
let NC_INVIS = Int32(8388608)


Signal.trap(Signal.INT) { v in
  endwin()
  exit(0)
}

setlocale(LC_ALL, "")

initscr()
start_color()
noecho()
curs_set(0)
keypad(stdscr, true)
mousemask(NC_BUTTON1_CLICKED, nil)
var debugy = Int32(2)
init_pair(1, Int16(COLOR_BLACK), Int16(COLOR_WHITE))
init_pair(2, Int16(COLOR_WHITE), Int16(COLOR_BLUE))
init_pair(3, Int16(COLOR_BLACK), Int16(266))
init_pair(4, Int16(COLOR_BLACK), Int16(COLOR_BLUE))
init_pair(5, Int16(COLOR_BLACK), Int16(COLOR_WHITE))
init_pair(6, Int16(COLOR_BLUE), 0)
var log = [String]()
func pd(s: String) {
  log.append(s)
}
pd("hello")
var nr = Int16(0)
var ng = Int16(0)
var nb = Int16(0)
color_content(Int16(COLOR_RED), &nr, &ng, &nb)
pd("r \(nr), g \(ng), b \(nb)")
pd("heart ção")
func plogs() {
  var len = log.count
  var si = len - 10
  if si < 0 {
    si = 0
  }
  var j = 0
  for i in si..<len {
    move(debugy + j, 80)
    addstr(log[i])
    j += 1
  }
}

assume_default_colors(-1, -1)

func printBoard() {
  let maxx = getmaxx(stdscr)
  let maxy = getmaxy(stdscr)
  move(0, 10)

  addstr("Title message! (maxy: \(maxy), maxx: \(maxx))")

  move(10, 10)
  addstr("Hello there, coração!")
  move(11, 7)
  addstr("<< Press CTRL+C to exit! >>")

  move(12, 12)
  addch(65)
  addch(66)
  addch(67)

  attroff(Int32.max)
  move(1, 18)
  addstr("╭───────────────────────────────────────────╮")
  move(2, 18)
  addstr("│                                           │")
  move(3, 18)
  addstr("╰───────────────────────────────────────────╯")
  attroff(Int32.max)
  move(2, 20)
  addstr(":>")
  attron(NC_UNDERLINE)
  addstr(" name   ")
  attroff(NC_UNDERLINE)
  addstr("::")
  attroff(Int32.max)
  addstr("     ")
  attron(COLOR_PAIR(2))
  addstr("!!")
  attron(NC_BOLD)
  addstr(" OK ")
  attroff(NC_BOLD)
  addstr("!!")
  attroff(Int32.max)
  addstr("   ")
  attron(COLOR_PAIR(2))
  addstr("!!")
  attron(NC_BOLD)
  addstr(" Cancel ")
  attroff(NC_BOLD)
  addstr("!!")
  attroff(Int32.max)

  attron(NC_REVERSE)
  move(7, 70)
  addstr("REVERSE")
  attroff(NC_REVERSE)
  attron(NC_STANDOUT)
  move(8, 70)
  addstr("STANDOUT")
  attroff(NC_STANDOUT)
  attron(NC_INVIS)
  move(9, 70)
  addstr("INVIS")
  attroff(NC_INVIS)
}

printBoard()

var py = Int32(11)
var px = Int32(10)

let CHAR = UInt(80)

var c: Int32 = 0

func drawAgain() {
  clear()
  move(30, 12)
  addstr("[\(c)] \(c == KEY_UP) mouse? \(c == KEY_MOUSE)")
  printBoard()
  move(py, px)
  addch(CHAR)
  plogs()
  refresh()
}

Signal.trap(SIGWINCH) { v in
  endwin()
  refresh()
  initscr()
  clear()
  drawAgain()
}

while true {
  drawAgain()
  c = getch()
  switch c {
    case KEY_UP:
      py -= 1
    case KEY_DOWN:
      py += 1
    case KEY_LEFT:
      px -= 1
    case KEY_RIGHT:
      px += 1
    case KEY_MOUSE:
      var ev = MEVENT()
      if getmouse(&ev) == OK {
        pd("mouse clicked OK \(inspect(ev))")
      }
    default: ()
  }
}
