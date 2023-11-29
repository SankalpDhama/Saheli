import 'package:flutter/material.dart';
import 'package:saheli/colors.dart';
import 'package:saheli/features.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'OpenService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  // final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenServices openAIService = OpenServices();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }
  Future <void> initSpeechToText() async {
    speechToText.initialize();
    setState(() {
    });
  }
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }
  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }
  // Future<void> systemSpeak(String content) async {
  //   await flutterTts.speak(content);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async{
        if(await speechToText.hasPermission && speechToText.isListening){
          startListening();
        }else if(speechToText.isListening){
          final speech=await openAIService.isArtPrompt(lastWords);
          print(speech);
          stopListening();
        }else{
          initSpeechToText();
        }
      },
      child: const Icon(Icons.mic), ),
      appBar: AppBar(
        title: const Text("Saheli"),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //assistant image
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/virtualAssistant.png'))),
                  ),
                ],
              ),
            ),
            //chat bubble
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin:
                  const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Pallete.borderColor),
                borderRadius:
                    BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: const Text(
                  'How Can I Help you Today',
                  style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.whiteColor,
                      fontSize: 25),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Here are Few Features',
                  style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            //features list
            Column(
              children: [
                Feature(color: Pallete.firstSuggestionBoxColor,header:'Chat-Gpt',description: "Prompt Generation",),
                Feature(color: Pallete.firstSuggestionBoxColor,header:'DallE',description: "Images Generation",),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
