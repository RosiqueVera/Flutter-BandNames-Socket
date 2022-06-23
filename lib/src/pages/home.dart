import 'dart:developer';

import 'package:band_name/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', Name: 'Queen', votes: 5),
    Band(id: '2', Name: 'Metallica', votes: 1),
    Band(id: '3', Name: 'Iron Maden', votes: 5),
    Band(id: '4', Name: 'Kiss', votes: 10),
    Band(id: '5', Name: 'Rolling Stones', votes: 6),
    Band(id: '6', Name: 'Queen', votes: 2),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Nombre de bandas',
            style: TextStyle(
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) => _bandTile(
            bands[index],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewBand,
          elevation: 1,
          child: const Icon(Icons.add_rounded),
        ));
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        //TODO: Borrado en el server
        log('Borrado de ${band.id}');
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.redAccent[700],
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Borrar bandas',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            band.Name.length <= 1 ? band.Name : band.Name.substring(0, 2),
          ),
        ),
        title: Text(band.Name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          log(band.Name);
        },
      ),
    );
  }

  addNewBand() {
    final TextEditingController textEditingController =
        new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nueva banda'),
          content: TextField(
            controller: textEditingController,
          ),
          actions: [
            MaterialButton(
              onPressed: () => addToList(textEditingController.text),
              child: Text('Agregar'),
              textColor: Colors.blueGrey,
              elevation: 5,
            )
          ],
        );
      },
    );
  }

  void addToList(String name) {
    if (name.isNotEmpty) {
      this
          .bands
          .add(new Band(Name: name, id: DateTime.now().toString(), votes: 0));
      setState(() {});
    }
    Navigator.of(context).pop();
  }
}
