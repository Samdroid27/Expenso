import 'package:flutter/material.dart';
import '../models/transaction.dart';

import './transaction_item.dart';

class TransactionList extends StatelessWidget {
 final List<Transaction> tractn;
 final Function delTx;

 TransactionList(this.tractn,this.delTx);
  
  @override
  Widget build(BuildContext context) {
    return  Container(
      
    child :tractn.isEmpty? LayoutBuilder(builder: (ctx,constraints){
      return Column(
      children: <Widget>[
        Text('No Transaction added yet'),
        SizedBox(
          height: 10,
        ),
        Container(
          height:constraints.maxHeight*0.6,
          child: Image.asset('assets/Images/waiting.png',
          fit: BoxFit.cover,),
          
          )
      ],
    );
    },)
   : ListView.builder(
      itemBuilder: (ctx,index){
        return TransactionItem(tractn:tractn[index], delTx: delTx);
        // return Card(
        //           child: Row(
        //             children: <Widget>[
        //               Container(
        //                 margin: EdgeInsets.symmetric(
        //                   vertical: 10,
        //                   horizontal: 15,  
        //                       ),
        //                 decoration: BoxDecoration(border: Border.all(
        //                   color: Theme.of(context).primaryColorDark,
        //                   width: 2,
        //                   style: BorderStyle.solid
        //                 )
        //                 ),
        //                 padding: EdgeInsets.all(10),
        //                 child: Text(
        //                   '₹ ${tractn[index].amount.toStringAsFixed(2)}',
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       fontStyle: FontStyle.italic ,
        //                       fontSize: 20,
        //                       color: Colors.green,                             
        //                   ),
        //                   ),
                         
        //                   ),
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: <Widget>[
        //                  Text(
        //                     tractn[index].title,
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       fontSize: 15,
        //                       color: Theme.of(context).primaryColor
        //                       ),
        //                       ),
        //                       Text(
        //                        DateFormat().format(tractn[index].date) ,
        //                        style: TextStyle(
        //                          fontWeight: FontWeight.bold,
        //                          fontSize: 15,
        //                          color: Colors.grey
        //                        ),),
        //                        Text(
        //                         tractn[index].id
        //                        )                                                    
        //                 ],
        //               )
        //             ],
        //           ),
        //         );
      },
      itemCount: tractn.length,
    )
        
            );
   
  }
}

