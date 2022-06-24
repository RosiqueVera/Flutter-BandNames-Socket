import 'package:band_name/services/socketService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Estado del servidor ${socketService.serverStatus}',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Map<String, String> message = {
            'name': 'Cliente Flutter',
            'message': 'Mensaje enviado desde el cliente flutter'
          };
          socketService.socket.emit(
            'emitir-mensaje',
            message,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ListTile(
                title: const Text(
                  'Mensje enviado',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  message.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.send_rounded),
      ),
    );
  }
}
