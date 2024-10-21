import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin UploadService {
  final supa = Supabase.instance.client;
  String bucketName = 'inspections';
  String rejectionAudioBasePath = 'rejection_audio';

  Future<bool> upload(File file) async {
    String fileName = file.path.split('/').last;
    print(file.path.split('.').last);
    print(file);
    try {
      await supa.storage
          .from(bucketName)
          .upload('$rejectionAudioBasePath/$fileName', file);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
