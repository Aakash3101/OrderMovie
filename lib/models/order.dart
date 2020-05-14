import 'package:firebase_database/firebase_database.dart';

class Orders {

  String key;
  String userId;
  String popcornSize;
  String beverage;
  String beverageSize;
  String seatNumber;
  String popQty;
  String bevQty;
  

  Orders(
    this.userId,
    this.popcornSize,
    this.beverage,
    this.beverageSize,
    this.popQty,
    this.bevQty,
    this.seatNumber
  );

  Orders.fromSnapshot(DataSnapshot snapshot) :
  key = snapshot.key,
  userId = snapshot.value["userId"],
  seatNumber = snapshot.value["seatNumber"],
  popcornSize = snapshot.value["popcornSize"],
  beverage = snapshot.value["beverage"],
  bevQty = snapshot.value['bevQty'],
  popQty = snapshot.value['popQty'],
  beverageSize = snapshot.value["beverageSize"];
  
  

  toJson() {
	  return {
	  	"userId": userId,
	  	"seatNumber": seatNumber,
	  	"popcornSize": popcornSize,
	  	"beverage": beverage,
      "beverageSize": beverageSize,
      "bevQty": bevQty,
      "popQty": popQty
	  };
	}
}