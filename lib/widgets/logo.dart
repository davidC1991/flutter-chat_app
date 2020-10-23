import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;

  const Logo({Key key, this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top:50),
        width: 200,
        child: Center(
          child: Column(
            children: [
              Image(image:AssetImage('assets/tag-logo.png')),
              SizedBox(height:20.0),
              Text(this.titulo)

            ],
          ),
        ),
      ),
    );
  }
}
