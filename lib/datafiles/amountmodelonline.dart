


class AmountModelOn {
  final int id;
  final int userid;
  final int amount;
  

  AmountModelOn({this.id,this.userid,this.amount,});

  @override
  String toString() {
    return '{ ${this.userid},${this.amount}, }';
  }
   AmountModelOn.fromDb(Map<String, dynamic> map)
      : id = int.parse(map['id']),
        userid =int.parse( map['user_id']),
        amount = int.parse(map['amount']);

   Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
      map['id'] = id;
      map['user_id']= userid;
      map['amount']= amount;

      return map;
      }
  }


