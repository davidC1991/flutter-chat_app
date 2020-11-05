

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/models/usuarios.response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;


class UsuarioResponse{

  Future<List<Usuario>> getUsuarios() async{
    try{
      final resp = await http.get('${Environment.apiUrl}/usuarios',
      headers:{
        'Content-Type' : 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usuarioResponse=usuariosResponseFromJson(resp.body);
      return usuarioResponse.usuarios;
      
    }catch(e){
      return [];
    }

  }
}

