import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height*.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(titulo: 'Messenger'),
                Form(),
                Labels(ruta:'register',mensaje1: '¿No tienes cuenta?',ingresa: 'Crea una cuenta!',),
                Text('Terminos y condiciones de uso', style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w300)),
             
                
              ],
            ),
          ),
        )
   ),
    );
  }
}


class Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:40),
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
         CustomInput(
           icon: Icons.mail_outline,
           placeholder: 'Correo',
           keyboardType: TextInputType.emailAddress,
           textController: emailCtrl,
         ),
         CustomInput(
           icon: Icons.lock_outline,
           placeholder: 'Contraseña',
           //keyboardType: TextInputType.pa,
           textController: passCtrl,
           isPassword: true,
         ),
         
          BotonAzul(
            texto:'Ingrese',
            onPressed: (){
              print(emailCtrl.text);
              print(passCtrl.text);
            },
            color: Colors.blue
          )
     
        
        ],
      ),
    );
  }
}

