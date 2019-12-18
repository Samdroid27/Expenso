import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {

  final Function addtrns;

  NewTransaction(this.addtrns);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleCtrl= TextEditingController();
  final _amtCtrl=TextEditingController();
  DateTime _selectedDate;

  void _submitData(){
    if(_amtCtrl.text.isEmpty){
      return;
    }
    final enteredTitle=_titleCtrl.text;
    final enteredAmt =double.parse(_amtCtrl.text) ;

    if(enteredAmt <0 || enteredTitle.isEmpty || _selectedDate==null) 
      return;

    widget.addtrns(
      enteredTitle,
      enteredAmt,
      _selectedDate
      );

    Navigator.of(context).pop();
  }

  void _presentDatePicker(){
    showDatePicker(
      context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2019),
    lastDate: DateTime.now()
    ).then((pickedDate){
      if (pickedDate == null)
       return;
       setState(() {
         _selectedDate = pickedDate; 
       });
      
    })  ;
  }

  @override
  Widget build(BuildContext context) {
     final isLandscape= MediaQuery.of(context).orientation == Orientation.landscape;
    return Card(
                  child: Container(
                    padding:isLandscape? EdgeInsets.all(5):EdgeInsets.all(10) ,
                    child:Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                          controller: _titleCtrl,
                         onSubmitted: (_) => _submitData()
                           ),
                            TextField(
                          decoration: InputDecoration(
                            labelText: 'Amount ',
                          ),
                          controller: _amtCtrl,
                           keyboardType: TextInputType.number,
                           onSubmitted: (_) => _submitData() ,
                           ),
                           Container(
                           height:isLandscape? 40 :90,
                            child :Row(children: <Widget>[
                            Expanded(
                               child: Text(_selectedDate ==null ?'No Date Chosen' : DateFormat.yMMMd().format(_selectedDate),
                                            style: TextStyle(
                                             fontSize: 15
                              ),
                              ),
                            ),
                            AdaptiveFlatButton('Choose Date', _presentDatePicker)
                            ],)
                           ),
                           RaisedButton(
                             child:Text('Add Transaction'),
                             color: Colors.purple,
                             textColor: Colors.white,
                             onPressed: _submitData,
                            )
                      ],
                    )
                  ),
                );
  }
}