import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  
  final textController= TextEditingController();
  final focusNode= FocusNode();
  bool estaEscribiendo =false;

  List<ChatMessage> message= [
   /*  ChatMessage(uid: '123',texto: 'Hola Mundo'),
    ChatMessage(uid: '123',texto: 'Hola Mundo'),
    ChatMessage(uid: '14423',texto: 'Hola Mundo'),
    ChatMessage(uid: '123',texto: 'Hola Mundo'),
    ChatMessage(uid: '14423',texto: 'Hola Mundo'), */
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 0,top:5),
              child: CircleAvatar(
                backgroundColor:Colors.blue[100],
                child: Text('Te',style: TextStyle(fontSize: 12),),
                maxRadius: 14,
              ),
            ),
            SizedBox(height: 3,),
            Text('Melissa Flores',style: TextStyle(color: Colors.black87,fontSize: 13),)
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: message.length,
                itemBuilder: (_,i)=>message[i],
                reverse: true,
              ),
            ),
            Divider(height: 1,),

            Container(
              color: Colors.white,
              height: 50,
              child: inputChat(),
            )
          ],
        ),
      )
   );
  }

  Widget inputChat(){
    return SafeArea(
      child:Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child:TextField(
                controller: textController,
                onSubmitted: handleSubmit,
                onChanged: (String texto){
                  //TODO: cuando hay un valor para poder postear
                  setState(() {
                    if(texto.trim().length>0){
                      estaEscribiendo= true;
                    }else{
                      estaEscribiendo=false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),  
                focusNode: focusNode,
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS?
                CupertinoButton(
                  child: Text('Enviar'),
                  onPressed: estaEscribiendo?
                          ()=> handleSubmit(textController.text.trim()) 
                          :null    ,
                ):Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.blue[400]),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                       icon: Icon(Icons.send,),
                       onPressed: estaEscribiendo?
                          ()=> handleSubmit(textController.text.trim()) 
                          :null    
                    ),
                  ) 
                ),
            )
          ],
        ),
      ) ,
    );
  }

  handleSubmit(String texto){
    if (texto.length==0) return;
    print(texto);
    textController.clear();
    focusNode.requestFocus();

    final newMessage = new ChatMessage(
                            uid: '123',
                            texto: texto,
                            animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)),
                            );
    message.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      estaEscribiendo=false;
    });
  }

  @override
  void dispose() {
    // TODO:off del socket
    for(ChatMessage message in message){
      message.animationController.dispose();
    }
    super.dispose();
  }
}
                      
                    
                    
                 