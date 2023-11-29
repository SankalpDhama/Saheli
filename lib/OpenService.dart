import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:saheli/secrets.dart';
class OpenServices{
  final List<Map<String,String>> messages=[];
  Future<String> isArtPrompt(String prompt) async{
    try{
      final res=await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers:{
        'Content-Type': 'application/json',
        'Authorization':'Bearer $openAiKey'
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages':[{
          'role':'user',
          'content' :' Does this message want to generate an Ai picture,image,art or anything similiar? $prompt .Simply answer it with yes or no',
        }
        ],
      },
      ),);
      print(res.body);
      if(res.statusCode==200){
        String content=jsonDecode(res.body)['choices'][0]['messages']['content'];
        content=content.trim();
        switch(content){
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res=await dallEApi(prompt);
            return res;
          default:
            final res=await ChatgptApi(prompt);
            return res;
        }
      }
      return 'an internal error occurred';
    }catch(e){
      return e.toString();
    }
  }
  Future<String> ChatgptApi(String prompt) async{
    messages.add({
      'role':'user',
      'content':prompt,
    },)
    try{
      final res=await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers:{
          'Content-Type': 'application/json',
          'Authorization':'Bearer $openAiKey'
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages':messages
        },
        ),);
      print(res.body);
      if(res.statusCode==200){
        String content=jsonDecode(res.body)['choices'][0]['messages']['content'];
        content=content.trim();
       messages.add({
         'role':'user',
         'content':prompt,
       });
      }
      return 'an internal error occurred';
    }catch(e){
      return e.toString();
    }
  }
  Future<String> dallEApi(String prompt) async{
    return 'Dall E';
  }
}