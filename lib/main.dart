import 'package:expenso/widgets/chart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import './models/transaction.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitUp
  //   ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenso',
      theme: ThemeData(primarySwatch: Colors.green, accentColor: Colors.amber),
      home: Expenso(),
    );
  }
}

class Expenso extends StatefulWidget {
  @override
  _ExpensoState createState() => _ExpensoState();
}

class _ExpensoState extends State<Expenso> {
  final List<Transaction> _transactions = [
    // Transaction(
    //     id: 't1', //DateFormat.y().format(DateTime.now()).toString()+DateFormat.M().format(DateTime.now())+DateFormat.d().format(DateTime.now())+DateFormat.m().format(DateTime.now()),
    //     title: 'Lunch',
    //     amount: 45,
    //     date: DateTime.now()),
    // Transaction(id: 't2', title: 'Jeans', amount: 1500, date: DateTime.now())
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        id: DateTime.now().toString(),
        date: chosenDate);

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    

    final isLandscape= MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text('Expenso'),
      actions: <Widget>[
        isLandscape?
        Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart'),
                Switch(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                )
              ],
            ):
        IconButton(
           icon: Icon(Icons.add),
           onPressed: () => _startAddNewTransaction(context),
         )
       ],
    );
    final txListWidget= Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.76,
                    child: TransactionList(_transactions, _deleteTransaction));
    return MaterialApp(
        home: Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            if(!isLandscape) Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.3,
                    child: Chart(_recentTransactions)),
            if(!isLandscape) txListWidget,
            
            if(isLandscape) _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
        backgroundColor: Theme.of(context).accentColor,
      ),
    ));
  }
}
