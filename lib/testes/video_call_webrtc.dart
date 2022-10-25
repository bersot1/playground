import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/io.dart';

class VideoCallWebrtc extends StatefulWidget {
  const VideoCallWebrtc({Key? key}) : super(key: key);

  @override
  State<VideoCallWebrtc> createState() => _VideoCallWebrtcState();
}

class _VideoCallWebrtcState extends State<VideoCallWebrtc> {
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  RTCPeerConnection? _peerConnection;
  final List<RTCRtpSender> _senders = [];

  String get sdpSemantics => 'unified-plan';

  bool _inCalling = false;
  bool _isMicEnabled = true;
  bool _isCamEnabled = true;

  late IOWebSocketChannel _channel;

  final Map<String, dynamic> mediaConstraints = {
    'audio': true,
    'video': {
      'facingMode': 'user',
    }
  };

  final loopbackConstraints = <String, dynamic>{
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': false},
    ],
  };

  final configuration = <String, dynamic>{
    'iceServers': [
      {
        'urls': 'stun:openrelay.metered.ca:80',
      },
      {
        'urls': 'turn:openrelay.metered.ca:80',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
      {
        'urls': 'turn:openrelay.metered.ca:443',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
      {
        'urls': 'turn:openrelay.metered.ca:443?transport=tcp',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
    ],
    // 'sdpSemantics': sdpSemantics,
  };

  // 1- guardar o id
  // 2 - var = localVideo, remoteVideo, connection(peerConnection), socket
  // 3- setLocalStream(null)
  // 4- setRemoteStream(null)
  // 5 - bool CameraAvailable, microfone, fullScreen, callEnded
  // 6 - setNewMessage ''
  // 7 - setMessages []
  // role = patient || professional

  Future<void> _makeCallv2() async {
    _peerConnection = await createPeerConnection(configuration, loopbackConstraints);

    _peerConnection!.onIceCandidate = (event) {
      if (event.candidate?.isNotEmpty == true) {
        final message = {
          "type": 'candidate',
          "appointment": 50,
          "role": 'patient',
          "candidate": event.candidate,
        };
        _channel.sink.add(jsonEncode(message));
        debugPrint('peerConnection :: onIceCandidate $jsonEncode(message)');
      }
    };

    _peerConnection!.onTrack = (event) {
      if (event.track.kind == 'video') {
        _remoteRenderer.srcObject = event.streams[0];
        _remoteStream = event.streams[0];
        debugPrint('peerConnection :: onTrack');
      }
    };

    _peerConnection!.onRemoveTrack = (stream, track) {
      if (track.kind == 'video') {
        _remoteRenderer.srcObject = null;
      }
    };

    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
      debugPrint('peerConnection :: addTrack');
    });
  }

  void connectWebSocket() {
    try {
      _channel.stream.listen((message) async {
        final _message = jsonDecode(message);
        debugPrint('message WSS:: $message');

        if (_message['type'] == 'start') {
          await _makeCallv2();
          debugPrint('peerConnection :: type start');
        }

        // offer
        // answer
        // OBS:: mobile nao precisa enviar offer
        // OBS:: vou receber um offer
        if (_message['type'] == 'offer') {
          // quebrar offer em 2 variaveis (type e SDP);
          final _type = _message['offer']['type'];
          final _sdp = _message['offer']['sdp'];
          await _peerConnection!.setRemoteDescription(RTCSessionDescription(_sdp, _type));
          final _answer = await _peerConnection!.createAnswer();
          await _peerConnection!.setLocalDescription(_answer);

          final _messageOffer = {
            "type": "answer",
            "appointment": 50,
            "role": 'patient',
            "answer": {
              "sdp": _answer.sdp,
              "type": _answer.type,
            },
          };

          _channel.sink.add(jsonEncode(_messageOffer));
          debugPrint('peerConnection :: type offer');
        }

        if (_message['type'] == 'candidate') {
          // var remoteDescription == _peerConnection.getRemoteDescription() => != FALSE or != null
          // a setRemoteDescription
          final remoteDescription = await _peerConnection!.getRemoteDescription();
          if (remoteDescription != null) {
            debugPrint('peerConnection :: ${_message['candidate']['candidate']}');
            debugPrint('peerConnection :: ${_message['candidate']['sdpMid']}');
            debugPrint('peerConnection :: ${_message['candidate']['sdpMLineIndex']}');

            _peerConnection!.addCandidate(RTCIceCandidate(
              _message['candidate']['candidate'],
              _message['candidate']['sdpMid'],
              _message['candidate']['sdpMLineIndex'],
            ));
            debugPrint('peerConnection :: type candidate');
          }

          _inCalling = true;
          setState(() {});
        }

        // se for type == candidate => parse do json e peerconection.addCandidate
      });

      const intialMessage = {
        'type': 'connect',
        'appointment': 50,
        'role': 'patient',
      };

      _channel.sink.add(jsonEncode(intialMessage));
    } on Exception catch (e) {
      print(e);
    }
  }

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void getLocalUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = localStream;
    _localStream = localStream;
    setState(() {});
  }

  void toggleMicrophone() {
    final audioStreamTrack = _localRenderer.srcObject!.getTracks().where((element) => element.kind == 'audio').first;
    if (audioStreamTrack.enabled) {
      audioStreamTrack.enabled = false;
      _isMicEnabled = false;
    } else {
      audioStreamTrack.enabled = true;
      _isMicEnabled = true;
    }
    setState(() {});
  }

  void toogleCam() {
    final camStreamTrack = _localRenderer.srcObject!.getTracks().where((element) => element.kind == 'video').first;

    if (camStreamTrack.enabled) {
      camStreamTrack.enabled = false;
      _isCamEnabled = false;
    } else {
      camStreamTrack.enabled = true;
      _isCamEnabled = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    _channel = IOWebSocketChannel.connect(Uri.parse('wss://booking.medislot.com:56112'));
    initRenderers();
    getLocalUserMedia();
    connectWebSocket();
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoopBack example'), actions: [
        IconButton(
            onPressed: toggleMicrophone,
            icon: _isMicEnabled ? const Icon(Icons.mic_off_outlined) : const Icon(Icons.mic_none_rounded)),
        IconButton(
            onPressed: toogleCam,
            icon: _isCamEnabled ? Icon(Icons.videocam_off) : const Icon(Icons.video_camera_back_rounded)),
      ]),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.green,
              child: _inCalling
                  ? RTCVideoView(
                      _remoteRenderer,
                      mirror: true,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    )
                  : const Center(
                      child: Text('Conectando...'),
                    ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 200,
            right: 20,
            child: Container(
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _isCamEnabled
                    ? RTCVideoView(
                        _localRenderer,
                        mirror: true,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              blurStyle: BlurStyle.solid,
                            ),
                          ],
                        ),
                        child: Center(
                          child: const Icon(Icons.videocam_off),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
