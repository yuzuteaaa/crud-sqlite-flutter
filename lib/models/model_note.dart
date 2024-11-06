class Note {
  int? id; // Nullable id untuk catatan yang baru dibuat
  String title;
  String description;

  Note({
    this.id, // id bersifat opsional
    required this.title,
    required this.description,
  });

  // Mengonversi objek Note ke map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  // Membuat objek Note dari map
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] != null ? map['id'] as int : null, // Memastikan id bisa null
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }
}
