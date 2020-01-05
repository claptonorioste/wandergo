


class ExpensesModelOn {
  final int id;
  final int userid;
  final int userExpenseId;
  final String label;
  final double amount;
  final int icon;
  final String date;
  final int isDeleted;
  ExpensesModelOn({this.id,this.userid,this.userExpenseId, this.label,this.amount,this.icon,this.date,this.isDeleted});

  @override
  String toString() {
    return '{ ${this.userid},${this.userExpenseId}, ${this.label},${this.amount},${this.icon},${this.date},${this.isDeleted} }';
  }
   ExpensesModelOn.fromDb(Map<String, dynamic> map)
      : id = int.parse(map['id']),
        userid =int.parse( map['user_id']),
        userExpenseId = int.parse(map['user_expense_id']),
        label = map['label'],
        amount = double.parse(map['amount']),
        icon = int.parse(map['icon']),
        date = map['date'],
        isDeleted = int.parse(map['isDeleted']);

   Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
      map['id'] = id;
      map['user_id']= userid;
      map['user_expense_id']= userExpenseId;
      map['label']=label;
      map['amount']= amount; 
      map['icon']= icon;
      map['date']= date;
      map['isDeleted']= isDeleted;
      return map;
      }
  }


