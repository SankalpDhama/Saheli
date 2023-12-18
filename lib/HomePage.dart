import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  final flutterTts = FlutterTts();
  String lastWords = '';
  String testingWords = 'how to make coffee';
  String promptText = '';
  final OpenServices openAIService = OpenServices();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  Future<void> initSpeechToText() async {
    speechToText.initialize();
    setState(() {});
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

  TextEditingController _textEditingController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  // Future<void> systemSpeak(String content) async {
  //   await flutterTts.speak(content);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            print('mic is on');
            startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIService.ChatgptApi(testingWords);
            // print(lastWords);
            // await systemSpeak(speech);
            print(lastWords);
            print(testingWords);
            print(speech);
            stopListening();
          } else {
            initSpeechToText();
            print('speech is on');
          }
        },
        child: Icon(speechToText.isListening?Icons.stop:Icons.mic),
      ),
      appBar: AppBar(
        title: BounceInDown(child: Text("Saheli")),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //assistant image
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ZoomIn(
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
            ),
            if(generatedImageUrl!=null)Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(borderRadius:BorderRadius.circular(20),child: Image.network(generatedImageUrl!)),
            ),
            //chat bubble
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl==null,
                child: Container(
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
                    child: Text(
                      generatedContent == null
                          ? 'Good Morning, what task can I do for you?'
                          : generatedContent!,
                      style: TextStyle(
                          fontFamily: 'Cera Pro',
                          color: Pallete.whiteColor,
                          fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent==null && generatedImageUrl==null,
                child: Container(
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
              ),
            ),
            //features list
            Visibility(
              visible: generatedContent==null && generatedImageUrl==null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay:Duration(milliseconds: start),
                    child: Feature(
                      color: Pallete.firstSuggestionBoxColor,
                      header: 'Prompt Generation',
                      description: "The LLM then generates an output based on both the query and the retrieved documents, this can be a useful technique for proprietary or dynamic information that was not included in the training or fine-tuning of the model.",
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start+delay),
                    child: Feature(
                      color: Pallete.firstSuggestionBoxColor,
                      header: 'Images Generation',
                      description: "AI image generators utilize trained artificial neural networks to create images from scratch. These generators have the capacity to create original, realistic visuals based on textual input provided in natural language. What makes them particularly remarkable is their ability to fuse styles, concepts, and attributes to fabricate artistic and contextually relevant imagery.",
                    ),
                  ),
                  TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(labelText: 'enter text'),
                    onChanged: (text) {
                      setState(() {
                        promptText = text;
                      });
                    },
                    onSubmitted: (text) async {
                      final res = await openAIService.isArtPrompt(promptText);
                      await systemSpeak(res);
                      if (res.contains('https')) {
                        generatedImageUrl = res;
                        generatedContent = null;
                        print(generatedImageUrl);
                        setState(() {});
                      } else {
                        generatedImageUrl = null;
                        generatedContent = res;
                        setState(() {});
                        await systemSpeak(res);
                      }
                      await stopListening();
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
