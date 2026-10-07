class MediaUploadResponse {
  final bool success;
  final String? url;
  final String? fileId;
  final String? message;

  MediaUploadResponse({
    required this.success,
    this.url,
    this.fileId,
    this.message,
  });

  factory MediaUploadResponse.fromJson(Map<String, dynamic> json) => MediaUploadResponse(
    success: json['success'] == true,
    url: json['url'],
    fileId: json['fileId'],
    message: json['message'],
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'url': url,
    'fileId': fileId,
    'message': message,
  };
}
