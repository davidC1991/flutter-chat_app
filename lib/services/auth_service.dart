
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_resnponse.dart';
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier{
  final _storage = new FlutterSecureStorage();
  Usuario usuario;
  bool _autenticando= false;

  bool get autenticando => this._autenticando;
  set autenticando(bool valor){
    this._autenticando= valor;
    notifyListeners();
  }
  static Future<String> getToken()async{
    final _storage = new FlutterSecureStorage();
    final token= await _storage.read(key: 'token');
    return token;
  }

  static Future<String> deleteToken()async{
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
   
  }

  Future login(String email, String password)async{
    this.autenticando=true;
    final data ={
      'email': email,
      'password': password
    };
    print('${ Environment.apiUrl }');
    final resp= await http.post(
      //'${ Environment.apiUrl }/login',
      'http://192.168.1.27:3000/api/login',
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
      await this.guardarToken(loginResponse.token);
      return true;
    }else {
      return false;
    }
    
  }

  Future registrar(String email, String password, String nombre)async{
    this.autenticando=true;
    final data ={
      'nombre':nombre,
      'email': email,
      'password': password
    };
    print('${ Environment.apiUrl }');
    final resp= await http.post(
      '${ Environment.apiUrl }/login/new',
      //'http://192.168.1.27:3000/api/login/new',
      body: jsonEncode(data),
      headers: {'Content-Type':'application/json'}
    );

    print(resp.body);
    print(resp.statusCode);
     this.autenticando=false;
    if(resp.statusCode==200 || resp.statusCode==500){
      final loginResponse= loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this.guardarToken(loginResponse.token);
      return true;
    }else {
      final respBody=jsonDecode(resp.body);

      return respBody['msg'];
    }
    
  }

  Future<bool> isLoggedIn() async{
    final token = await this._storage.read(key: 'token');
    print(token);
    
    
    final resp= await http.get(
      //'${ Environment.apiUrl }/login/renew',
      'http://192.168.1.27:3000/api/login/renew',
     
      headers: {
        'Content-Type':'application/json',
        'x-token': token
        }
    );
    print(token);
    print(resp.body);
    print(resp.statusCode);
    
    if(resp.statusCode==200 || resp.statusCode==500){
      final loginResponse= loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this.guardarToken(loginResponse.token);
      return true;
    }else {
      this.logout();
      return false;
    }
    print('|||||');
  }
      


  Future guardarToken(String token)async{
    return await _storage.write(key: 'token', value: token);
  }

  Future logout()async{
    await _storage.delete(key: 'token');
  }
  

}