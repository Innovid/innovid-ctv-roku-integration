function init() as Void
  m.log = _Logger("SimpleSSAI / VideoPlayback")
  m.top.observeField("action", "handleActionChanged")

  m.video = m.top.findNode("_video")
  m.content = invalid
  m.started = false
  m.size = { w : 1280, h : 720 }

  m.playbackState = ""
  m.playbackPosition = -1

  m.restartPosition = -1
  m.restartRequested = false
  m.restarting = false

  m.irollAd = invalid
  m.irollAdInfo = invalid
end function

function handleActionChanged(evt_ as Object) as Void
  action_ = evt_.getData()

  if action_.type = "start" then
    prepare( action_.width, action_.height )
    startPlayback( action_.data )
  else if action_.type = "stop" then
    stopPlayback()
  end if
end function

function startPlayback(data_ as Object) as Void
  if m.started then return

  content_ = CreateObject("roSGNode", "ContentNode")
  content_.setFields( data_.content )

  m.log.i("startPlayback()", content_)

  m.video.observeField("position", "handlePlaybackStateChanged")
  m.video.observeField("state", "handlePlaybackStateChanged")

  m.video.notificationInterval = .5
  m.video.enableUI = false
  m.video.content = content_
  m.video.control = "play"

  m.ads = data_.ads
  m.data = data_
  m.started = true
end function

function stopPlayback() as Void
  m.log.i("stopPlayback()")

  if m.video <> invalid then
    m.video.control = "stop"
  end if

  if m.irollAd <> invalid then
    removeirollAd()
  end if

  m.started = false
end function

function checkAds() as Void

  for each adInfo_ in m.ads
    if shouldStartAd( adInfo_ ) then
      startIrollAd( adInfo_ )
    end if
  end for
end function

function handlePlaybackStateChanged(evt_ as Object) as Void
  positionChanged_ = false
  stateChanged_ = false

  if m.video.position <> m.playbackPosition then
    m.playbackPosition = m.video.position
    positionChanged_ = true
  end if

  if m.video.state <> m.playbackState then
    m.playbackState = m.video.state
    stateChanged_ = true
  end if

  if positionChanged_ then
    checkAds()
  end if

  if m.irollAd <> invalid and (positionChanged_ or stateChanged_) then
    m.irollAd.action = {
      type      : "notifyPlaybackStateChanged",
      position  : m.video.position,
      state     : m.video.state
    }
  end if
end function

function shouldStartAd(adInfo_ as Object) as Boolean
  return not( adInfo_.started ) and not( adInfo_.viewed ) and abs(adInfo_.renderTime - m.playbackPosition) < .5
end function

function prepare(w_, h_) as Void
  m.log.i("prepare()")

  m.size = { w : w_, h : h_ }

  m.video.width = w_
  m.video.height = h_
  m.video.translation = [0, 0]
end function
