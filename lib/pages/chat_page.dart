import 'package:chat_app/models/mensajes_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:chat_app/services/socketServides.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chatService.dart';

import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  
  final textController= TextEditingController();
  final focusNode= FocusNode();
  bool estaEscribiendo =false;
  ChatService chatService;
  SocketService socketService;
  AuthService authService;



  List<ChatMessage> message= [
   /*  ChatMessage(uid: '123',texto: 'Hola Mundo'),
    ChatMessage(uid: '123',texto: 'Hola Mundo'),
    ChatMessage(uid: '14423',texto: 'Hola Mundo'),
    ChatMessage(uid: '123',texto: 'Hola Mundo'),
    ChatMessage(uid: '14423',texto: 'Hola Mundo'), */
  ];


  @override
  void initState() { 
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal',_escucharMensaje);

    cargarHistorial(this.chatService.usuarioPara.uid);
  }

  cargarHistorial(String usuarioID)async{
    List<Mensaje> chat= await this.chatService.getChat(usuarioID);
    print(chat);
    final history= chat.map((m) => new ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward()
    ));

    setState(() {
      message.insertAll(0, history);
      print(message[0].texto);
    });
  }
  void _escucharMensaje(dynamic data){
    print('Tengo mensaje! $data');
    ChatMessage message1 = new ChatMessage(
      texto: data['mensjaje'],
      uid: data['de'],
      animationController: AnimationController(vsync: this,duration: Duration(milliseconds:500 ),
    ));

    setState(() {
      this.message.insert(0, message1);
    });

    message1.animationController.forward();
  }
  @override
  Widget build(BuildContext context) {

    final usuarioPara = this.chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 0,top:5),
              child: CircleAvatar(
                backgroundColor:Colors.blue[100],
                child: Text(usuarioPara.nombre.substring(0,2),style: TextStyle(fontSize: 12),),
                maxRadius: 14,
              ),
            ),
            SizedBox(height: 3,),
            Text(usuarioPara.nombre,style: TextStyle(color: Colors.black87,fontSize: 13),)
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
                            uid: authService.usuario.uid,
                            texto: texto,
                            animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)),
                            );
    message.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      estaEscribiendo=false;
    });

    this.socketService.emit('mensaje-personal',{
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    // TODO:off del socket
    for(ChatMessage message in message){
      this.socketService.socket.off('mensaje-personal');
      message.animationController.dispose();
    }
    super.dispose();
  }
}
                      
                    
                    
                 