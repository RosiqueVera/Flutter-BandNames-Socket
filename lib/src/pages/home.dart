import 'package:band_name/models/band.dart';
import 'package:band_name/services/socketService.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(
      context,
      listen: false,
    );
    socketService.socket.on(
      'active-bands',
      (payload) {
        _handleActiveBands(payload);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
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
          elevation: 1,
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: socketService.serverStatus == ServerStatus.online
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent[400],
                      )
                    : Icon(
                        Icons.offline_bolt_rounded,
                        color: Colors.redAccent[400],
                      ))
          ],
        ),
        body: Column(
          children: [
            showGraph(),
            Expanded(
              child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (BuildContext context, int index) => _bandTile(
                  bands[index],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewBand,
          elevation: 1,
          child: const Icon(Icons.add_rounded),
        ));
  }

  //?Método para mostrar la lista de las bandas al usuario
  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.socket.emit(
        'delete-band',
        {'id': band.id},
      ),
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
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () => socketService.socket.emit(
          'add-vote',
          {'id': band.id},
        ),
      ),
    );
  }

  //? Método que inicializa la lista
  void _handleActiveBands(payload) {
    bands = (payload as List)
        .map(
          (band) => Band.fromMap(band),
        )
        .toList();
    setState(() {});
  }

  //? Método que muestra el dialogo para agregar una nueva banda
  addNewBand() {
    final TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva banda'),
        content: TextField(
          controller: textEditingController,
        ),
        actions: [
          MaterialButton(
            onPressed: () => addToList(textEditingController.text),
            textColor: Colors.blueGrey,
            elevation: 5,
            child: const Text('Agregar'),
          )
        ],
      ),
    );
  }

  showGraph() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    Map<String, double> dataMap = Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.Name, () => band.votes.toDouble());
    });
    return socketService.serverStatus == ServerStatus.online
        ? SizedBox(
            width: double.infinity,
            height: 200,
            child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                showLegends: true,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
                decimalPlaces: 0,
              ),
            ),
          )
        : Text(
            ('Se necesitan datos para generar la gráfica'),
          );
  }

  //? Método para agregarlo a la lista
  void addToList(String name) {
    if (name.isNotEmpty) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.of(context).pop();
  }
}
