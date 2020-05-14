import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ordermovie/models/order.dart';

class MyDialog extends StatefulWidget {
  MyDialog({Key key, this.userId, this.seatNum}) : super(key: key);

  final String userId;
  final String seatNum;

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<String> _bevnames = ['Coca Cola', 'Pepsi', 'Mirinda', 'Sprite'];
  String bevName = '';
  String popSize = '';
  String bevSize = '';
  String popQty;
  String bevQty;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    this.popSize = null;
    this.bevSize = null;
    this.bevName = null;
    this.popQty = '0';
    this.bevQty = '0';
    super.initState();
  }

  addNewOrders(String popCorn, String bevType, String bevSize, String bevqty,
      String popqty) {
    Orders orders = Orders(widget.userId, popCorn, bevType, bevSize, popqty,
        bevqty, widget.seatNum);
    _database.reference().child("orders").push().set(orders.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
            height: 500.0,
            width: 500.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'PopCorn Size',
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                            fontStyle: FontStyle.normal),
                      ),
                      Container(
                        width: 15.0,
                      ),
                      Text(
                        'Qty',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      ListTileItem(
                        onCountvalue: (count) {
                          this.popQty = count;
                        },
                      )
                    ],
                  ),

                  DropdownButtonFormField<String>(
                    items: _sizes.map((String newVal) {
                      return DropdownMenuItem<String>(
                        value: newVal,
                        child: Text(newVal),
                      );
                    }).toList(),
                    value: popSize,
                    hint: Text('Popcorn Size'),
                    onChanged: (String newValue) {
                      setState(() {
                        this.popSize = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 20.0,),

                  Text(
                    'Beverage Name',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20.0,
                        fontStyle: FontStyle.normal),
                  ),
                  DropdownButtonFormField<String>(
                    items: _bevnames.map((String newVal) {
                      return DropdownMenuItem<String>(
                        value: newVal,
                        child: Text(newVal),
                      );
                    }).toList(),
                    value: bevName,
                    hint: Text('Beverage Name'),
                    onChanged: (String newValue) {
                      setState(() {
                        this.bevName = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 20.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Beverage Size',
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                            fontStyle: FontStyle.normal),
                      ),
                      Container(
                        width: 15.0,
                      ),
                      Text(
                        'Qty',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      ListTileItem(
                        onCountvalue: (count) {
                          this.bevQty = count;
                        },
                      )
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    items: _sizes.map((String newVal) {
                      return DropdownMenuItem<String>(
                        value: newVal,
                        child: Text(newVal),
                      );
                    }).toList(),
                    value: bevSize,
                    hint: Text('Beverage Size'),
                    onChanged: (String newValue) {
                      setState(() {
                        this.bevSize = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 20.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),),
                          child: Text('Save', style: TextStyle(color: Colors.black), textScaleFactor: 1.15,),
                          color: Colors.amberAccent,
                          elevation: 14.0,
                          onPressed: () {
                            addNewOrders(
                                popSize, bevName, bevSize, bevQty, popQty);
                            Navigator.of(context).pop();
                          }),

                      SizedBox(width: 15.0,),    
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),),
                        color: Colors.black87,
                        child: Text('Cancel', textScaleFactor: 1.15,),
                        elevation: 14.0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ])));
  }
}

class ListTileItem extends StatefulWidget {
  final ValueChanged<String> onCountvalue;

  ListTileItem({Key key, this.onCountvalue}) : super(key: key);
  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  int _itemCount = 0;
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Row(
        children: <Widget>[
          _itemCount != 0
              ? new IconButton(
                  icon: new Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _itemCount--;
                    });
                    widget.onCountvalue(this._itemCount.toString());
                  },
                )
              : new Container(
                  width: 5.0,
                ),
          new Text(_itemCount.toString()),
          new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _itemCount++;
                });
                widget.onCountvalue(_itemCount.toString());
              })
        ],
      ),
    );
  }
}
