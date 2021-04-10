import 'dart:io';

/// Интерфейс загрузки фотографий.
// ignore: one_member_abstracts
abstract class UploadRepository {
  const UploadRepository();

  Future<String?> uploadPhoto(File file);
}

