function startIrollAd(adInfo_ as Object) as Void
  if m.irollAd <> invalid then
    remoteIroll( m.irollAd )
  end if

  m.log.i("startIroll()", adInfo_)

  m.irollAdInfo = adInfo_
  m.irollAdInfo.started = true

  m.irollAd = m.top.createChild("InnovidAds:DefaultIrollAd")
  m.irollAd.id = adInfo_.id

  ' @see iroll-event-handler.brs
  m.irollAd.observeField("event", "handleIrollEvent")
  m.irollAd.observeField("request", "handleIrollPlaybackRequest")

  ' link to the json file
  url_ = adInfo_.companions[0].url
  ' !important the iroll's default size is 1280x720
  ' in other cases ( the host app uses FHD mode ) the host app should specify the exact size
  w_ = m.size.w
  h_ = m.size.h

  ' on this call iroll only will start load a json tag
  m.irollAd.action = {
    type   : "init",
    uri    : url_,
    width  : m.size.w,
    height : m.size.h,
    ssai   : {
      adapter    : "default",               ' !important
      duration   : m.irollAdInfo.duration   ' !important
      renderTime : m.irollAdInfo.renderTime ' !important
    }
  }

  ' on this call iroll will start render an ad overlay
  m.irollAd.action = { type : "start" }
end function

function removeirollAd() as Void
  if m.irollAdInfo <> invalid then
    m.irollAdInfo.viewed = true
  end if

  ' unload ad
  m.irollAd.action = { type : "unload" }
  ' get container
  irollAdContainer = m.irollAd.getParent()

  if irollAdContainer <> invalid then
    irollAdContainer.removeChild( m.irollAd )
  end if

  m.irollAd = invalid
  m.irollAdInfo = invalid
end function

function handleIrollEvent(evt_ as Object) as Void
  adEvent_ = evt_.getData()
  adId_ = evt_.getNode()

  ' adEvent : {
  '   type  : string,
  '   data? : object
  ' }

  m.log.i("handleIrollEvent(" + adId_ + ", " + adEvent_.type + ")")
end function

' supported requests
'  -- "request-playback-pause"
'  -- "request-playback-resume"
'  -- "request-playback-prepare-to-restart" - iroll invokes this before opening a secondary player
'  -- "request-playback-restart"
function handleIrollPlaybackRequest(evt_ as Object) as Void
  request_ = evt_.getData()
  adId_ = evt_.getNode()

  ' request_ : {
  '   type : string,
  '   position? : float ' used in
  ' }

  m.log.i("handleIrollPlaybackRequest(" + adId_ + ", type: " + request_.type + ")")

  if request_.type = "request-playback-pause" then
    m.video.control = "pause"
  else if request_.type = "request-playback-resume" then
    m.video.control = "resume"
  else if request_.type = "request-playback-prepare-to-restart" then
    m.restartRequested = true
    m.restartPosition = m.video.position
    m.video.control = "stop"
  else if request_.type = "request-playback-restart" then
    m.restarting = true
    m.restartRequested = false
    m.video.control = "play"
    m.video.seek = m.restartPosition
  end if
end function
