import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class  ChatMessage extends StatelessWidget {
 
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key key,
    this.texto,
    this.uid,
    this.animationController
  }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final authService= Provider.of<AuthService>(context,listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.bounceInOut),
        child: Container(
          child: this.uid == authService.usuario.uid
          ? _myMessage()
          : _noMyMessage()
        ),
      ),
    );
  }

  Widget _myMessage(){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5.0, left: 50.0,right: 5.0),
        child: Text(this.texto, style: TextStyle(color:Colors.white),),
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }
  Widget _noMyMessage(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5.0, left: 5.0,right: 50.0),
        child: Text(this.texto, style: TextStyle(color:Colors.black87),),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }
}