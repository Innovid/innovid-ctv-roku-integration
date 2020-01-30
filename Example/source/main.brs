function main() as Void
  screen = CreateObject("roSGScreen")
  port = CreateObject("roMessagePort")

  screen.SetMessagePort( port )

  ' integration tester
  scene = screen.CreateScene("Examples")
  screen.Show()

  ' inject data
  scene.content = getTestExamples()

  while (true)
    msg = wait(0, port)

    if type( msg ) = "roSGScreenEvent" and msg.isScreenClosed() then
      exit while
    end if
  end while
end function

function getTestExamples() as Object
  data = ParseJson(ReadAsciiFile("pkg:/data/examples.json"))
  result = CreateObject("roSGNode", "ContentNode")

  for each e in data.examples
    example = CreateObject("roSGNode", "ContentNode")
    example.addField("type", "string", false)
    example.addField("content", "assocarray", false)
    example.addField("ads", "array", false)
    example.setFields( e )

    ? example
    result.appendChild( example )
  end for

  return result
end function
