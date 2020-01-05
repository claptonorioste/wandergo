
class ExpensesModel {

  final int id;
  final String label;
  final double amount;
  final int icon;
  final String date;
  final int isDeleted;

 

  ExpensesModel({this.id, this.label,this.amount,this.icon,this.date,this.isDeleted});

  @override
  String toString() {
    return '{ ${this.id}, ${this.label},${this.amount},${this.icon},${this.date},${this.isDeleted} }';
  }

  ExpensesModel.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        label = map['label'],
        amount =  map['amount'],
        icon =  map['icon'] ,
        date =  map['date'],
        isDeleted = map['isDeleted']
        ;

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['label'] = label;
    map['amount'] = amount;
    map['icon'] = icon;
    map['date'] = date;
    map['isDeleted'] = isDeleted;
    return map;
  }
}
