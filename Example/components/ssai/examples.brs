function init() as Void
  m.log = _Logger("Examples")
  m.log.d("init()")

  m.started  = false
  m.disposed = false
  m.ready    = false

  m.example = invalid
  m.exampleData = Invalid

  m.examples = m.top.findNode("_examples")
  m.examples.observeField("itemSelected", "handleExampleSelected")

  m.top.observeField("content", "handleContentChanged")

  m.lib = m.top.findNode("_lib")
  m.lib.observeField("loadStatus", "handleLibLoadStatus")

  ' defines innovid-iroll-renderer log's level
  ' ALL   - 0
  ' DEBUG - 10
  ' INFO  - 20
  ' WARN  - 30
  ' ERROR - 40 -- DEFAULT
  _Globals().set("LoggerLevel", 0)

  m.examples.setFocus((m.ready = true))
end function

function startExample(data as Object) as Void
  if m.started then
    disposeExample()
  end if

  m.log.i("startExample()", data)

  m.exampleData = data

  ' create and initialize demo
  m.example = m.top.createChild("SimpleSSAIVideoPlayback")
  m.example.id = data.id
  m.example.translation = [0, 0]
  m.example.action = {
    type   : "start",
    data   : data,
    width  : 1920,
    height : 1080
  }

  m.started = true
end function

function disposeExample() as Void
  if not( m.started ) or m.example = invalid then
    return
  end if

  container = m.example.getParent()

  m.log.i("disposeExample()")

  m.example.action = { type : "stop" }
  m.example.unobserveField("event")

  if container <> invalid then
    container.removeChild( m.example )

    ' for index = 0 to container.getchildcount() - 1
    '   ? container.id;": ";index;" -- (id: ";container.getchild(index).id;", subtype: ";container.getchild(index).subtype();")"
    ' end for
  end if

  m.example = invalid
  m.started = false

  ' return focus back to the examples list
  m.examples.setFocus( true )
end function

function handleExampleSelected(evt as Object) as Void
  startExample(m.top.content.getchild( evt.getData() ))
end function

function handleContentChanged() as Void
  m.examples.content = m.top.content
end function

function handleLibLoadStatus() as Void
  m.log.i("handleLibLoadStatus()", m.lib.loadStatus)

  if (m.lib.loadStatus = "ready") then
    m.ready = true
    m.examples.setFocus( true )
  end if
end function

function onKeyEvent(key as String, isKeyDown as Boolean) as Boolean
  if not( isKeyDown ) or not( m.ready ) then
    return false
  end if

  m.log.d("onKeyEvent(" + key + ", " + isKeyDown.ToStr() + ")")

  if key = "back" then
    disposeExample()
    return true
  end if

  return false
end function
