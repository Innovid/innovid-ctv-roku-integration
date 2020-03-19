Innovid IRoll // Direct Integration 
===================================

This simple example demonstrates how to integrate Innovid iRoll Renderer into your app

## How to run this example
```bash
cd Example
make install ROKU_DEV_TARGET=<ROKU_IP> DEVPASSWORD=<ROKU_DEV_PASSWORD>
```

## Integration

#### Add Innovid iRoll Renderer component to your scene xml

**Production** version
```xml
<ComponentLibrary id="_lib"
  uri="https://s-video.innovid.com/common/roku/innovid-iroll-renderer-sg.pkg" />
```

**QA** version
```xml
<ComponentLibrary id="_lib"
  uri="https://s-video.innovid.com/common/roku/innovid-iroll-renderer-sg-qa.pkg" />
```

#### How to create Innovid iRoll instance
```brightscript

' example or json url - http://video.innovid.com/tags/static.innovid.com/roku-hulu/1ikm30.json?cb=20180216
' @param String url_       - json file url ( as it defined in VAST )
' @param Float duration_   - duration of iroll ad ( as it defined in VAST )
' @param Float renderTime_ - relative position of iroll ad from beginning of SSAI content
function createIrollAd(url_ as String, duration_ as Float, renderTime_ as Float) as  Void
  m.irollAd = m.top.createChild("InnovidAds:DefaultIrollAd")
  m.irollAd.id = 'iroll-ad'
  m.irollAd.observeFieldScoped("event", "handleIrollEvent")
  m.irollAd.observeFieldScoped("request", "handleIrollPlaybackRequest")
  m.irollAd.action = {
    type   : "init",
    uri    : url_,   ' required!
    width  : 1280,   ' required!
    height : 720,    ' required!
    ssai : {         ' required!
      adapter    : "default",
      renderTime : renderTime_,
      duration   : duration_
    },
   userCanCloseInteractive?: boolean  ' @optional -- defines if user can close interactive part by clicking on back 
   fallback? : {                      ' @optional -- indicates the renderer should disable an interactive part
      enabled: true,
      details: string
   }, 
  }

  irollAd.action = { type : "start" }
end function
```

#### How to push the playback updates to iRoll instance
The iRoll instance does not listen to the video node events, therefore the host app must provide video playback updates in case of `video.position` or `video.state` change

You can find the sample implementation in [`components/ssai/iroll-handler.brs`][ssai_example_injecting_video_events]

```brightscript
' video.observeFieldScoped("position", "handlePlaybackStateChanged")
' video.observeFieldScoped("state", "handlePlaybackStateChanged")

function handlePlaybackStateChanged(evt_ as Object) as Void
  video_ = evt_.getRoSGNode()

  m.irollAd.action = {
    type     : "notifyPlaybackStateChanged",
    position : video_.position,
    state    : video_.state
  }
end function
```

Also, the host app should handle iRoll playback requests.
you can find the sample implementation in [`components/ssai/iroll-handler.brs`][ssai_example_handling_playback_requests]

```brightscript
' m.irollAd.observeFieldScoped("request", "handleIrollPlaybackRequest")

function handleIrollPlaybackRequest(evt_ as Object) as Void
  request_ = evt_.getData()
  adId_ = evt_.getNode()

  ' request_ : {
  '   type : string,
  '   position? : float ' used in
  ' }

  ? "handleIrollPlaybackRequest(";adId_;", type: ";request_.type;")"

  if request_.type = "request-playback-pause" then
    ' add pause video playback code here
  else if request_.type = "request-playback-resume" then
    ' add resume video playback code here
  else if request_.type = "request-playback-prepare-to-restart" then
    ' this method called before iroll opens a secondary video player
    ' so, the host app should ( in general )
    ' - save a playback position
    ' - completely stop the current player
  else if request_.type = "request-playback-restart" then
    ' this method called after iroll closes a microsite and try to resume ssai playback, the host app should restart a playback from saved position
  end if  
end function
```

#### How to listen to iRoll Ad events
List of supported events

| Event              | Description                               |
| ------------------ | ----------------------------------------- |
| `Impression`       | Start of ad render (e.g., first frame of a video ad displayed)
| `FirstQuartile`    | 25% of video ad rendered
| `Midpoint`         | 50% of video ad rendered
| `ThirdQuartile`    | 75% of video ad rendered
| `Complete`         | 100% of video ad rendered
| `AcceptInvitation` | User launched another portion of an ad (for interactive ads)
| `Error`            | Error during ad rendering
| `Expand`           | the user activated a control to expand the creative.
| `Collapse`         | the user activated a control to reduce the creative to its original dimensions.
| `Close`            | User exited out of ad rendering before completion
| `Pause`            | User paused ad
| `Resume`           | User resumed ad
| `Ended`            | Ended
| `exitWithSkipAdBreak` | *TrueX // Pod Skip* when user exits interactive ad unit having earned an ad-free ad break.
| `exitWithAdFree`      | *TrueX // Stream Skip* when user exits interactive ad unit having earned an ad-free stream.
| `exitAutoWatch`       | *TrueX // Auto Advance* when the choice card auto advance timer has expired.
| `exitSelectWatch`     | *TrueX // Select Normal Ads*  when the user selects to watch normal ads.
| `exitBeforeOptIn`     | *TrueX // Close Interactive Ad* when the user exits the `choice_card` with `back` button press
| `OverlayClosed`     | CBS // Interactive part has closed, ad will not resopnse to remote anymore
```brightscript
' irollAd.observeFieldScoped("event", "handleIrollEvent")

function handleIrollEvent(evt as Object) as Void
  adEvent = evt.getData()
  adId = evt.getNode()

  ' adEvent : {
  '   type  : string,
  '   data? : object
  ' }

  ? "handleIrollEvent(";adId;", ";adEvent.type;")"
end function
```

[ssai_example_injecting_video_events]: https://github.com/Innovid/innovid-ctv-roku-integration/blob/master/Example/components/ssai/simple-ssai-video-playback.brs#L95
[ssai_example_handling_playback_requests]: https://github.com/Innovid/innovid-ctv-roku-integration/blob/master/Example/components/ssai/iroll-handler.brs#L77
