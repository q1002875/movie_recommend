// Trailer类
class Trailer {
  final String key; // YouTube链接的关键部分
  final String name;

  Trailer({required this.key, required this.name});

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      key: json['key'],
      name: json['name'],
    );
  }
}
