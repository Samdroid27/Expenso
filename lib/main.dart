import 'dart:io';

import 'package:expenso/widgets/chart.dart';
import 'package:flutter/cupertino.dart';
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
    
    final mediaQuery=MediaQuery.of(context);
    final isLandscape= mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar =Platform.isIOS? CupertinoNavigationBar(
      middle: Text('Expenso'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () =>  _startAddNewTransaction(context),
          )
        ],
      ),
    )
    : AppBar(
      title: Text('Expenso'),
      actions: <Widget>[
        isLandscape && Platform.isAndroid ?
        Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart'),
                Switch.adaptive(
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
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.76,
                    child: TransactionList(_transactions, _deleteTransaction));
    
    final pageBody=SafeArea(child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            if(!isLandscape) Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.3,
                    child: Chart(_recentTransactions)),
            if(!isLandscape) txListWidget,
            
            if(isLandscape) _showChart
                ? Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                           mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txListWidget
          ],
        ),
      )
    );
    return MaterialApp(
        home:Platform.isIOS?CupertinoPageScaffold(
          child: pageBody,
          navigationBar:appBar ,
          ) 
          : Scaffold(
      appBar: appBar,
      body:pageBody ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:Platform.isIOS? 
      Container()
      : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
        backgroundColor: Theme.of(context).accentColor,
      ),
    )
    );
  }
}
