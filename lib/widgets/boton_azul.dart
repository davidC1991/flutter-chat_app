import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String texto;
  final Function onPressed;
  final Color color;
 

  const BotonAzul({
    Key key,
    @required this.texto,
    @required this.onPressed,
    this.color=Colors.blue
  }) : super(key: key);
  @override
    
  Widget build(BuildContext context) {
    return  RaisedButton(
           onPressed: this.onPressed,
           elevation: 2,
           highlightElevation: 5,
           color: this.color,
           shape: StadiumBorder(),
           child: Container(
             height: 55,
             width: double.infinity,
             child: Center(
               child:Text(this.texto, style: TextStyle(color:Colors.white),) 
             ),
           ),
          );
  }
}