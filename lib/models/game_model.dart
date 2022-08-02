class GameModel {
  GameModel({this.name, this.imageUrl});
  String? name;
  String? imageUrl;

  GameModel.fromMap(Map<String, dynamic> mapData) {
    name = mapData['name'];
    imageUrl = mapData['imageUrl'];
  }
}
