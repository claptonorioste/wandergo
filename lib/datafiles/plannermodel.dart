


class PlannerModel {
  final int id;
  final String listLabel;
  final String date;
  final int isDone;
  final int isDeleted;


  

  PlannerModel({this.id,this.date,this.listLabel,this.isDone,this.isDeleted});

  @override
  String toString() {
    return '{ ${this.id},${this.date},${this.listLabel},${this.isDone}, }';
  }
   PlannerModel.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        listLabel = map['listLabel'],
        date = map['date'],
        isDone = map['isDone'],
        isDeleted = map['isDeleted'];

   Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
      map['id'] = id;
      map['listLabel'] = listLabel;
      map['date'] = date;
      map['isDone']= isDone;
      map['isDeleted'] = isDeleted;

      return map;
      }
  }


