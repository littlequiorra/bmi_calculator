import 'dart:convert';
import '../Controller/sqlite_db.dart';
import '../Controller/request_controller.dart';


class BMI {
  static const String SQLiteTable = "bmi";
  String fullname;
  double weight;
  double height;
  String gender;
  String bmiStatus;
  BMI(this.fullname,this.weight,this.height, this.gender, this.bmiStatus );

  BMI.fromJson(Map<String, dynamic> json)
      : fullname = json['username'] as String,
        weight = double.parse(json['weight'] as dynamic),
        height = double.parse(json['height'] as dynamic),
        gender = json['gender'] as String,
        bmiStatus= json['bmi_status'] as String;


  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() =>
      {'weight': weight, 'height': height, 'gender':gender , 'bmi_status':bmiStatus };

  Future<bool> save() async {
    //Save to local SQlite
    await SQLiteDB().insert(SQLiteTable, toJson());
    //API Operation
    RequestController req = RequestController(path: "/api/bmi.php");
    req.setBody(toJson());
    await req.post();
    if (req.status()==200) {
      return true;
    }
    else
    {
      if (await SQLiteDB().insert(SQLiteTable, toJson())!=0) {
        return true;
      }
      else {
        return false;
      }
    }
  }

  static Future<List<BMI>> loadAll() async {
    List<BMI> result =[];
    RequestController req = RequestController(path: "/api/bmi.php");
    await req.get();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        result.add(BMI.fromJson(item));
      }
    }
    else
    {
      List <Map<String, dynamic>> result = await SQLiteDB().queryAll(SQLiteTable);
      List <BMI> bmis = [];
      for (var item in result) {
        result.add(BMI.fromJson(item) as Map<String, dynamic>);
      }
    }

    return result;
  }
}