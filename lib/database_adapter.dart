import 'dart:typed_data';

abstract class DatabaseAdapter {
  Future<void> storeImage(Uint8List imageBytes);

  Future<List<Uint8List>> getImages();
}

