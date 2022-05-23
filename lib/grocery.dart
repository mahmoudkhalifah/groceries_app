class Grocery {
  int? id;
  late String name;

  Grocery({this.id,required this.name});

  Grocery.fromMap(Map<String,dynamic> map) {
    id = map["id"];
    name = map["name"];
  }

  Map<String,dynamic> toMap() {
    return {
      'id':id,
      'name':name
    };
  }
}