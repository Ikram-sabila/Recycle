class Group {
  final String id;
  final String nama;
  final String imageUrl;

  Group({required this.id, required this.nama, required this.imageUrl});

  factory Group.fromFirestore(Map<String, dynamic> data, String id) {
    return Group(
        id: id,
        nama: data['nama'],
        imageUrl: data['image']
    );
  }
}