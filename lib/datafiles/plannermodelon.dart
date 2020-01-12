


class PlannerOnline {
  final int id;
  final int userid;
  final int userplannerid;
  final String label;
  final String date;
  final int isDone;
  final int isDelete;

  PlannerOnline({this.id,this.userid,this.userplannerid, this.label,this.date,this.isDone,this.isDelete});

  @override
  String toString() {
    return '{ ${this.userid},${this.userplannerid}, ${this.label},${this.date},${this.isDone},${this.isDelete} }';
  }
   PlannerOnline.fromDb(Map<String, dynamic> map)
      : id = int.parse(map['id']),
        userid =int.parse( map['user_id']),
        userplannerid = int.parse(map['planner_id']),
        label = map['label'],
        date = map['date'],
        isDone = int.parse(map['isDone']),
        isDelete = int.parse(map['isDelete']);

   Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
      map['id'] = id;
      map['user_id']= userid;
      map['planner_id']= userplannerid;
      map['label']=label;
      map['date']= date;
      map['isDone']= isDone;
      map['isDelete']= isDelete;
      return map;
      }
  }


