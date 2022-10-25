import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallWebrtcBkp extends StatefulWidget {
  const VideoCallWebrtcBkp({Key? key}) : super(key: key);

  @override
  State<VideoCallWebrtcBkp> createState() => _VideoCallWebrtcBkpState();
}

class _VideoCallWebrtcBkpState extends State<VideoCallWebrtcBkp> {
  // 1 - initianize localRenderer and remote initRenderers()

  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  final List<RTCRtpSender> _senders = [];
  bool _inCalling = false;

  String get sdpSemantics => 'unified-plan';
  Timer? _timer;

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _hangUp() async {
    try {
      await _localStream?.dispose();
      await _peerConnection?.dispose();
      _peerConnection = null;
      _localRenderer.srcObject = null;
      _remoteRenderer.srcObject = null;
    } catch (e) {
      print(e);
    }

    setState(() {
      _inCalling = false;
    });
  }

  void _sendDtmf() async {
    var rtpSender = _senders.firstWhere((element) => element.track?.kind == 'audio');

    var dtmfSender = rtpSender.dtmfSender;
    await dtmfSender.insertDTMF('123#');
  }

  void _makeCall() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    final configuration = <String, dynamic>{
      'iceServers': [
        {
          'url': 'https://booking.medislot.com/appointments/31/video',
        }

        //     iceServers: [
        //     {
        //         urls: 'stun:openrelay.metered.ca:80',
        //     },
        //     {
        //         urls: 'turn:openrelay.metered.ca:80',
        //         username: 'openrelayproject',
        //         credential: 'openrelayproject',
        //     },
        //     {
        //         urls: 'turn:openrelay.metered.ca:443',
        //         username: 'openrelayproject',
        //         credential: 'openrelayproject',
        //     },
        //     {
        //         urls: 'turn:openrelay.metered.ca:443?transport=tcp',
        //         username: 'openrelayproject',
        //         credential: 'openrelayproject',
        //     },
        // ],

        // const signalingServer = 'wss://cloud.publiduplo.com:4041/'; -> return address do médico

        // {'url': 'stun:stun.l.google.com:19302'},
        // https://www.metered.ca/tools/openrelay/
      ],
      'sdpSemantics': sdpSemantics,
    };

    final offerSdpConstraints = <String, dynamic>{
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': [],
    };

    final loopbackConstraints = <String, dynamic>{
      'mandatory': {},
      'optional': [
        {'DtlsSrtpKeyAgreement': false},
      ],
    };

    if (_peerConnection != null) return;

    try {
      MediaStream localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = localStream;

      _peerConnection = await createPeerConnection(configuration, loopbackConstraints);

      _peerConnection!.onSignalingState = _onSignalingState;
      _peerConnection!.onIceGatheringState = _onIceGatheringState;
      _peerConnection!.onIceConnectionState = _onIceConnectionState;
      _peerConnection!.onConnectionState = _onPeerConnectionState;
      _peerConnection!.onIceCandidate = _onCandidate;
      _peerConnection!.onRenegotiationNeeded = _onRenegotiationNeeded;

      switch (sdpSemantics) {
        case 'plan-b':
          _peerConnection!.onAddStream = _onAddStream;
          _peerConnection!.onRemoveStream = _onRemoveStream;
          await _peerConnection!.addStream(_localStream!);
          break;

        case 'unified-plan':
          _peerConnection!.onTrack = _onTrack;
          _peerConnection!.onAddTrack = _onAddTrack;
          _peerConnection!.onRemoveTrack = _onRemoveTrack;
          _localStream!.getTracks().forEach((track) async {
            _senders.add(await _peerConnection!.addTrack(track, _localStream!));
          });
          break;
      }

      var description = await _peerConnection!.createOffer(offerSdpConstraints);
      var sdp = description.sdp;
      print('sdp = $sdp');
      await _peerConnection!.setLocalDescription(description);

      var sdpAnswer = sdp?.replaceAll('setup:actpass', 'setup:active');
      var descriptionAnswer = RTCSessionDescription(sdpAnswer, 'answer');
      await _peerConnection!.setRemoteDescription(descriptionAnswer);
    } catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    _timer = Timer.periodic(const Duration(seconds: 1), handleStatsReport);

    setState(() {
      _inCalling = true;
    });
  }

  void handleStatsReport(Timer timer) async {
    if (_peerConnection != null) {
      var reports = await _peerConnection?.getStats();
      reports?.forEach((report) {
        print('report => { ');
        print('    id: ' + report.id + ',');
        print('    type: ' + report.type + ',');
        print('    timestamp: ${report.timestamp},');
        print('    values => {');
        report.values.forEach((key, value) {
          print('        ' + key + ' : ' + value.toString() + ', ');
        });
        print('    }');
        print('}');
      });
    }
  }

  void _onTrack(RTCTrackEvent event) {
    print('onTrack');
    if (event.track.kind == 'video') {
      _remoteRenderer.srcObject = event.streams[0];
    }
  }

  void _onAddTrack(MediaStream stream, MediaStreamTrack track) {
    if (track.kind == 'video') {
      _remoteRenderer.srcObject = stream;
    }
  }

  void _onRemoveTrack(MediaStream stream, MediaStreamTrack track) {
    if (track.kind == 'video') {
      _remoteRenderer.srcObject = null;
    }
  }

  void _onRemoveStream(MediaStream stream) {
    _remoteRenderer.srcObject = null;
  }

  void _onAddStream(MediaStream stream) {
    print('New stream: ' + stream.id);
    _remoteRenderer.srcObject = stream;
  }

  void _onRenegotiationNeeded() {
    print('RenegotiationNeeded');
  }

  void _onCandidate(RTCIceCandidate candidate) {
    print('onCandidate: ${candidate.candidate}');
    _peerConnection?.addCandidate(candidate);
  }

  void _onSignalingState(RTCSignalingState state) {
    print(state);
  }

  void _onIceGatheringState(RTCIceGatheringState state) {
    print(state);
  }

  void _onIceConnectionState(RTCIceConnectionState state) {
    print(state);
  }

  void _onPeerConnectionState(RTCPeerConnectionState state) {
    print(state);
  }

  @override
  void initState() {
    // initRenderers();
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (_inCalling) {
      _hangUp();
    }

    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[
      Expanded(
        child: RTCVideoView(_localRenderer, mirror: true),
      ),
      Expanded(
        child: RTCVideoView(_remoteRenderer),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoopBack example'),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.red,
              child: Text('doctor'),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 200,
            right: 20,
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 2,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text('patient'),
            ),
          )
        ],
      ),
    );
  }
}
