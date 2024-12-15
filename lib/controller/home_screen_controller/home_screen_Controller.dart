import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class homescreencontroller with ChangeNotifier {
  double _progress = 0.0;
  bool _isUploading = false;
  bool _isFailed = false;
  String? filePath;
  VideoPlayerController? _videoController;
  UploadTask? _currentUploadTask;

  double get progress => _progress;
  bool get isUploading => _isUploading;
  bool get isFailed => _isFailed;
  VideoPlayerController? get videoController => _videoController;

  final ImagePicker _picker = ImagePicker();

  ///  code for Picks and uploads  file
  Future<void> pickAndUploadFile(BuildContext context) async {
    try {
      final pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No file selected')));
        return;
      }

      filePath = pickedFile.path;

      // to  Check file size greater than 100mb
      final file = File(filePath!);
      final fileSizeInBytes = await file.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB < 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File size must be at least 100 MB.')),
        );
        return;
      }

      /// code for checkimg its video
      if (filePath!.endsWith('.mp4')) {
        _initializeVideo(filePath!);
      }

      // code for start upload
      await _uploadFile(filePath!, context);
    } catch (e) {
      _isFailed = true;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error selecting or uploading file')),
      );
    }
  }

  /// code for Initializes the video for preview
  void _initializeVideo(String filePath) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        _videoController!.setLooping(true);
        _videoController!.play();
        notifyListeners();
      }).catchError((error) {
        _videoController = null;
        notifyListeners();
      });
  }

  /// Uploads a file to Firebase Storage
  // Future<void> _uploadFile(String filePath, BuildContext context) async {
  //   try {
  //     _isUploading = true;
  //     _isFailed = false;
  //     _progress = 0.0;
  //     notifyListeners();

  //     final file = File(filePath);
  //     final fileName = filePath.split('/').last;

  //     final storageRef = FirebaseStorage.instance.ref('uploads/$fileName');
  //     _currentUploadTask = storageRef.putFile(file);

  //     _currentUploadTask!.snapshotEvents.listen((event) {
  //       _progress = event.bytesTransferred / event.totalBytes;
  //       notifyListeners();
  //     });

  //     await _currentUploadTask!.whenComplete(() {});
  //     final downloadUrl = await storageRef.getDownloadURL();

  //     _isUploading = false;
  //     notifyListeners();

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Upload successful: $downloadUrl')),
  //     );
  //   } catch (e) {
  //     _isUploading = false;
  //     _isFailed = true;
  //     notifyListeners();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Upload failed. Please try again.')),
  //     );
  //   }
  // }
  Future<void> _uploadFile(String filePath, BuildContext context) async {
    try {
      _isUploading = true;
      _isFailed = false;
      _progress = 0.0;
      notifyListeners();

      print("Starting upload for file: $filePath");
      final file = File(filePath);
      final fileName = filePath.split('/').last;

      // code for to take Firebase Storage Reference
      final storageRef = FirebaseStorage.instance.ref('uploads/$fileName');
      final uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        _progress = event.bytesTransferred / event.totalBytes;
        notifyListeners();
      });

      await uploadTask.whenComplete(() {});
      final downloadUrl = await storageRef.getDownloadURL();
      print('File uploaded successfully. Download URL: $downloadUrl');

      _isUploading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File uploaded successfully: $fileName')),
      );
    } catch (e) {
      print("Upload failed: $e");
      _isUploading = false;
      _isFailed = true;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload failed. Please try again.')),
      );
    }
  }

  void retryUpload(BuildContext context) {
    if (filePath != null) {
      pickAndUploadFile(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected to retry upload.')),
      );
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
