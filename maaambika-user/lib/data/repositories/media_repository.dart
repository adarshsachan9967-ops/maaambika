import '../models/media_model.dart';

class MediaRepository {
  Future<MediaUploadResponse> uploadFile({
    required String filePath,
    String? folder,
  }) async {
    // Media upload logic (ImageKit / Supabase / local upload)
    return MediaUploadResponse(
      success: true,
      url: 'https://ik.imagekit.io/casmik/uploads/sample.jpg',
      fileId: 'file-${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
