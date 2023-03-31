import 'package:avatar_glow/avatar_glow.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:library_app/models/book.dart';
import 'package:library_app/utilities/api.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MicButton extends StatefulWidget {
  const MicButton({super.key});

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  String _text = '';
  final SpeechToText _speech = SpeechToText();
  double confidence = 1.0;
  bool available = false;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  void _initSpeech() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await _speech.initialize(
      debugLogging: true,
      onStatus: (status) {
        if (status == 'done') {
          print(_text);
          if (_text.isNotEmpty) {
            queryInput();
          }

          setState(() {});
        }
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: Theme.of(context).primaryColor,
      animate: _speech.isListening,
      endRadius: 60,
      child: FloatingActionButton(
        onPressed: _speech.isNotListening ? _startListening : _stopListening,
        child: Icon(_speech.isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }

  void _startListening() async {
    await _speech.listen(
      listenFor: const Duration(seconds: 5),
      onResult: (result) {
        _text = result.recognizedWords;
        if (result.hasConfidenceRating && result.confidence > 0) {
          confidence = result.confidence;
        }
      },
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  void queryInput() async {
    var response = await api.post(
      '/resolve-query',
      data: FormData.fromMap({
        "text": _text,
      }),
    );
    print(response.data);
    _speak(response.data['reply']);
    if (!mounted) return;
    if (response.data['result'] is List) {
      final booklist = Book.listFromJson(response.data['result']);
      if (booklist.isNotEmpty) {
        Navigator.pushNamed(context, '/booklist', arguments: booklist);
      }
    }
    if (response.data['result'] is Map) {
      final book = Book.fromJson(response.data['result']);
      Navigator.pushNamed(context, '/book', arguments: book);
    }
  }

  Future _speak(text) async {
    await flutterTts.speak(text);
    _text = "";
  }
}
