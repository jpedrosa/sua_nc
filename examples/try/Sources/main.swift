

import Glibc
import CSua
import CNC
import SuaNC


try NC.start() { div in
  NC.pd("Hello World!")
  NC.mainDiv.borderTop = true
  NC.mainDiv.borderRight = true
  NC.mainDiv.borderBottom = true
  NC.mainDiv.borderLeft = true
  var o = NCText()
  var intervalCounter = 0
  NC.interval(2) { timer in
    o.text = "Something OVNI \(intervalCounter) else"
    NC.pd("intervalCounter \(intervalCounter)")
    intervalCounter += 1
  }
  o.text = "OVNI"
  o.borderTop = true
  o.borderBottom = true
  o.borderLeft = true
  o.borderRight = true
  try div.span("Water", "Ice", "Fire", o) { span in
    span.verticalAlign = .Center
    span.borderTop = true
    span.borderBottom = true
    span.borderLeft = true
    span.borderRight = true
  }
  try div.span("Second row!")
  try div.span("Third and here we are!")
  try div.span("Maxwell")
  try div.span("Disk")
  var clip = NCText()
  clip.text = "CLIPPED"
  clip.borderTop = true
  clip.borderRight = true
  clip.borderBottom = true
  clip.borderLeft = true
  clip.maxWidth = 5
  try div.span(clip)
  var spanClip = NCSpan()
  var tryMsg = NCText()
  tryMsg.text = "Try and you might get it."
  tryMsg.borderTop = true
  spanClip.add(tryMsg)
  spanClip.maxWidth = 10
  spanClip.add("[For realz!]")
  try div.span(spanClip)
  try div.span("Santo Amaro foi um município até 1935, quando foi anexado a São Paulo.  A sede do munícipio conhecida pela comunidade santo amarense como Casa Amarela (foto) hoje abriga o Paço Cultural Júlio Guerra, no coração do Largo 13 e vizinho ao coreto.")
  try div.span("Employee") { span in
    span.align = .Center
    span.borderTop = true
    span.borderBottom = true
    span.borderLeft = true
    span.borderRight = true
    span.expandWidth = true
  }
  var space = NCText()
  space.text = "Space"
  space.expandWidth = true
  try div.span(space, "Customers") { span in
    span.borderTop = true
    span.borderBottom = true
    span.borderLeft = true
    span.borderRight = true
    span.expandWidth = true
  }
  var leftSpace = NCText()
  leftSpace.expandWidth = true
  var rightSpace = NCText()
  rightSpace.text = ""
  rightSpace.expandWidth = true
  try div.span(leftSpace, "Victory!", rightSpace) { span in
    span.borderTop = true
    span.borderBottom = true
    span.borderLeft = true
    span.borderRight = true
    span.expandWidth = true
  }
  var align = NCText()
  align.text = "Align Me"
  align.align = .Center
  align.expandWidth = true
  try div.span(align) { span in
    span.borderTop = true
    span.borderBottom = true
    span.borderLeft = true
    span.borderRight = true
    span.expandWidth = true
  }
  try div.span("Leo")
  try div.span("[=Goodness=]") { span in
    // span.backgroundStrings = ["TextArea"]
    span.borderTop = true
    span.borderBottom = true
    span.borderLeft = true
    span.borderRight = true
    // span.expandWidth = true
    span.expandHeight = true
  }
  try div.span("Mirror") { span in
    //span.backgroundStrings = ["TextArea"]
    span.borderTop = true
    span.borderBottom = true
    span.borderLeft = true
    span.borderRight = true
    // span.expandWidth = true
    // span.expandHeight = true
    try span.div { div in
      try div.span("Embedded")
      try div.span("Second line embedded")
    }
  }
  try div.span("Device") { span in
    span.width = 20
    span.backgroundStrings = ["Practical"]
    span.borderTop = true
    span.borderBottom = true
    span.borderLeft = true
    span.borderRight = true
    span.expandHeight = true
  }
  try div.span("zinho")
}
