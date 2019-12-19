import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';


class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.tractn,
    @required this.delTx,
  }) : super(key: key);

  final Transaction tractn;
  final Function delTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 5
      ),
      child: ListTile(
          leading: CircleAvatar(
            radius: 40,
            child:Padding( 
              padding: EdgeInsets.all(6),
            child:FittedBox(
              child: Text(
                 '₹ ${tractn.amount.toStringAsFixed(2)}'
                 ),
            ),
            )
            ),
            title: Text(
               tractn.title,
               style: TextStyle(
                 
                 fontWeight: FontWeight.bold,
                 color: Colors.purple
               ),
               ),
            subtitle: Text(
              DateFormat.yMMMd().format(tractn.date)
            ),
            trailing:MediaQuery.of(context).size.width > 560 ?
            FlatButton.icon(
              icon:Icon(Icons.delete),
              label: Text('delete'),
              textColor: Colors.red,
              onPressed: () => delTx(tractn.id)
            )
            :
             IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => delTx(tractn.id),
              ),
        ),
      
    );
  }
}