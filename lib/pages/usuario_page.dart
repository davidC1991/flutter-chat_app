import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chatService.dart';
import 'package:chat_app/services/socketServides.dart';
import 'package:chat_app/services/usuariosService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/models/usuario.dart';


class UsuarioPage extends StatefulWidget {

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  RefreshController _refreshController =RefreshController(initialRefresh: false);
  final usuariosService =  UsuarioResponse();
  List<Usuario> usuarios= [];
  /* final usuarios=[
    Usuario(uid: '1',nombre: 'Maria', email: 'maria@hotmai.com', online: true),
    Usuario(uid: '2',nombre: 'Carlos', email: 'Carlos@hotmai.com', online: true),
    Usuario(uid: '3',nombre: 'Juan', email: 'Juan@hotmai.com', online: false),
    Usuario(uid: '4',nombre: 'Jeison', email: 'Jeison@hotmai.com', online: true),
  ]; */

  @override
  void initState() {
    this.cargarUsuarios();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService=Provider.of<SocketService>(context);
    final usuario= authService.usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre,style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: IconButton(
        
          icon: (socketService.serverStatus==ServerStatus.Online)?Icon(Icons.exit_to_app,color: Colors.blue,):
                 Icon(Icons.exit_to_app,color: Colors.red,),
          onPressed: (){
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          }
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child:Icon(Icons.check_circle,color: Colors.blue[600])
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check,color:Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        child: listViewUsuarios(),
      )
   );
  }

  ListView listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (_,i)=>Divider(),
      itemCount: usuarios.length,
      itemBuilder: (_,i)=> usuarioListTile(usuarios[i]),
     
    );
  }

  ListTile usuarioListTile(Usuario usuario){
    return ListTile(
        title: Text(usuario.nombre),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2)),
          backgroundColor: Colors.blue[600],
        ),
        subtitle: Text(usuario.email),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online? Colors.green[600]:Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: (){
          print(usuario.nombre);
          print(usuario.email);
          final chatService =Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara= usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  cargarUsuarios()async{
      //await Future.delayed(Duration(milliseconds: 1000));
      this.usuarios= await usuariosService.getUsuarios();
      setState(() {});
      _refreshController.refreshCompleted();
  }
   
}