import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  CoinData coinData = CoinData();

  String selectedCurrency = 'USD';

  //value had to be updated into a Map to store the values of all three cryptocurrencies.
  Map<String, String> coinValues = {};
  //7: Figure out a way of displaying a '?' on screen while we're waiting for the price data to come back. First we have to create a variable to keep track of when we're waiting on the request to complete.
  bool isWaiting = false;

  void getData() async {
    //7: Second, we set it to true when we initiate the request for prices.
    isWaiting = true;
    try {
      //6: Update this method to receive a Map containing the crypto:price key value pairs.
      var data = await CoinData().getCoinData(selectedCurrency);
      //7. Third, as soon the above line of code completes, we now have the data and no longer need to wait. So we can set isWaiting to false.
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }
  // var coinValue = coinData['rate'];


  DropdownButton<String> getDropDownButton(){
    List<DropdownMenuItem<String>> dropdownItems = [];

    for(String currency in currenciesList){

      var newDropdownItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropdownItems.add(newDropdownItem);

    }

    return
      DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value){
          setState(() {
            selectedCurrency = value!;

            getData();
          });

        },
      );
  }

  CupertinoPicker getCupertinoPicker(){
    List<Text> cupertinoItems = [];

    for(String currency in currenciesList){

      var newCupertinoItem = Text(currency);

      cupertinoItems.add(newCupertinoItem);

    }

    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex){
          print(selectedIndex);
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];

            getData();
          });
        },
        children: cupertinoItems
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'BTC',
            value: isWaiting ? '?' :coinValues['BTC'],

          ),
          CryptoCard(
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'ETH',
            value: isWaiting ? '?' : coinValues['ETH'],

          ),
          CryptoCard(
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'LTC',
            value: isWaiting ? '?' : coinValues['LTC'],

          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getCupertinoPicker() : getDropDownButton()
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key? key,
    required this.selectedCurrency,
    required this.cryptoCurrency,
    required this.value
  }) : super(key: key);


  final String selectedCurrency;
  final String cryptoCurrency;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

