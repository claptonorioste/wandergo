//main class
class AmountModel {

  final int id;
  final double amount;

 

  AmountModel({this.id,this.amount});

  @override
  String toString() {
    return '{ ${this.id},${this.amount}}';
  }

  AmountModel.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        amount =  map['amount']
        ;

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['amount'] = amount;
    return map;
  }
}

