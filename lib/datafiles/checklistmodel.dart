


class ChecklistModel {
  final int id;
  final String listLabel;
  final bool value;
  

  ChecklistModel({this.id,this.listLabel,this.value,});

  @override
  String toString() {
    return '{ ${this.id},${this.listLabel},${this.value}, }';
  }
   ChecklistModel.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        listLabel = map['listLabel'],
        value = map['value'];

   Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
      map['id'] = id;
      map['listLabel']= listLabel;
      map['value']= value;

      return map;
      }
  }


