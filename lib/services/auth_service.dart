
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_resnponse.dart';
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier{
  Usuario usuario;
  bool _autenticando= false;

  bool get autenticando => this._autenticando;
  set autenticando(bool valor){
    this._autenticando= valor;
    notifyListeners();
  }

  Future login(String email, String password)async{
    this.autenticando=true;
    final data ={
      'email': email,
      'password': password
    };
    print('${ Environment.apiUrl }');
    final resp= await http.post(
      '${ Environment.apiUrl }/login',
      body: jsonEncode(data),
      headers: {
        'Content-Type':'application/json'
      }
    );

    print(resp.body);
    print(resp.statusCode);
     this.autenticando=false;
    if(resp.statusCode==200 || resp.statusCode==500){
      final loginResponse= loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      return true;
    }else {
      return false;
    }
    
  }

}