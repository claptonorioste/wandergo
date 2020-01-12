


class SocialModel {
  final int id;
  final int userid;
  final String label;
  final String fileName;
  final String fullname;
  

  SocialModel({this.id,this.userid,this.label,this.fileName,this.fullname});

  @override
  String toString() {
    return '{ ${this.userid},${this.label},${this.fileName},${this.fullname} }';
  }
   SocialModel.fromDb(Map<String, dynamic> map)
      : id = int.parse(map['id']),
        userid = int.parse(map['user_id']),
        label = map['label'],
        fileName =map['image'],
        fullname =map['user_full_name'];
       

   Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
      map['id'] = id;
      map['user_id']= userid;
      map['label']= label;
      map['image']= fileName;
      map['user_full_name']= fullname;

      return map;
      }
  }


