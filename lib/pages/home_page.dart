import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ordermovie/models/order.dart';
import 'package:ordermovie/services/authentication.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:ordermovie/pages/makeorder.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Orders> _orderList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  StreamSubscription<Event> _onOrderAddedSubscription;
  StreamSubscription<Event> _onOrderChangedSubscription;

  Query _addQuery;

  @override
  void initState() {
    super.initState();

    _orderList = List();
    _addQuery = _database
        .reference()
        .child("orders")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onOrderAddedSubscription = _addQuery.onChildAdded.listen(onEntryAdded);
    _onOrderChangedSubscription =
        _addQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  void dispose() {
    _onOrderAddedSubscription.cancel();
    _onOrderChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _orderList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _orderList[_orderList.indexOf(oldEntry)] =
          Orders.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _orderList.add(Orders.fromSnapshot(event.snapshot));
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  // addNewOrders(String seatNum, String popCorn, String beverage, String bevQty) {
  //   Orders orders = Orders(widget.userId, popCorn, beverage, bevQty, seatNum);
  //   _database.reference().child("orders").push().set(orders.toJson());
  // }

  deleteOrders(String orderId, int index) {
    _database.reference().child("orders").child(orderId).remove().then((_) {
      print("Delete $orderId successful");
      setState(() {
        _orderList.removeAt(index);
      });
    });
  }

  Widget showAddsList() {
    if (_orderList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _orderList.length,
          itemBuilder: (BuildContext context, int index) {
            String orderId = _orderList[index].key;
            String popCorn = _orderList[index].popcornSize;
            String beverage = _orderList[index].beverage;
            String beverageSize = _orderList[index].beverageSize;
            String userId = _orderList[index].userId;
            String seatNo = _orderList[index].seatNumber;
            String popQty = _orderList[index].popQty;
            String bevQty = _orderList[index].bevQty;

            return Dismissible(
              key: Key(orderId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                deleteOrders(orderId, index);
              },
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                      child: ListTile(
                    contentPadding: EdgeInsets.all(15.0),
                    title: Text(
                      'Seat Number: $seatNo',
                      style:
                          TextStyle(fontSize: 17.0, color: Colors.orange[300]),
                      textScaleFactor: 1.15,
                    ),
                    subtitle: Card(
                        elevation: 7.0,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Popcorn Size: $popCorn \t\tPopcorn Quantity: $popQty'
                            '\nBeverage Name: $beverage'
                            '\nBeverage Size: $beverageSize \t\tBeverage Quantity: $bevQty',
                            textScaleFactor: 1.05,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                        )),
                  ))),
            );
          });
    } else {
      return Center(
          child: Text(
        "Your Orders",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28.0),
      ));
    }
  }

  String result = "";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        showDialog(
            context: context,
            builder: (_) {
              return MyDialog(
                userId: widget.userId,
                seatNum: result,
              );
            });
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Order'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                  child: Icon(
                    Icons.power_settings_new,
                    color: Colors.black,
                  ),
                  onPressed: signOut),
              FlatButton(
                child: Icon(
                  Icons.refresh,
                  color: Colors.black87,
                ),
                onPressed: () {
                  if (result != '') {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return MyDialog(
                            userId: widget.userId,
                            seatNum: result,
                          );
                        });
                  }
                },
              ),
              FlatButton(
                child: Text(
                  'Reset',
                  textScaleFactor: 1.25,
                  style: TextStyle(color: Colors.black),
                ),
                autofocus: true,
                onPressed: () {
                  this.result = '';
                },
              )
            ],
          )
        ],
      ),
      body: showAddsList(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
