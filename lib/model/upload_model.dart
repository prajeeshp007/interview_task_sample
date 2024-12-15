class UploadModel {
  String filename;
  double progress;
  bool isuploading;
  bool isfailed;
  UploadModel(
      {required this.filename,
      this.progress = 0.0,
      this.isuploading = false,
      this.isfailed = false});
}
