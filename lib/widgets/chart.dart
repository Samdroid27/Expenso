import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String,Object>> get groupedTransactionVal {
    return List.generate(7, (index){
      final weekday= DateTime.now().subtract(Duration(days: index));
      var totalSum= 0.0;
      for(var i=0; i<recentTransactions.length ; i++)
      {
        if(recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year)
            {
              totalSum+=recentTransactions[i].amount;
            }
      }
      
      return {
        'day':DateFormat.E().format(weekday).substring(0,1),
        'amount':totalSum};
    }).reversed.toList();
  }

  double get totalSpending{
    return groupedTransactionVal.fold(0.0, (sum,item){
        return sum+item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 6,
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Row( 
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  groupedTransactionVal.map((data){
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: data['day'],
                  spendingAmount: data['amount'],
                  spendingPctOfTotal: totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending,
                  ),
              
            );
          }).toList()
          ),
        
      ) 
    );
  }
}