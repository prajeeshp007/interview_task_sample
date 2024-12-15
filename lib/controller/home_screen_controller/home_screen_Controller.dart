// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';

// class UploadController with ChangeNotifier {
//   double _progress = 0.0;
//   bool _isUploading = false;
//   bool _isFailed = false;
//   String? filePath; // File path for the selected file
//   VideoPlayerController? _videoController;

//   double get progress => _progress;
//   bool get isUploading => _isUploading;
//   bool get isFailed => _isFailed;
//   VideoPlayerController? get videoController => _videoController;

//   final ImagePicker _picker = ImagePicker();

//   Future<void> pickAndUploadFile(BuildContext context) async {
//     try {
//       final pickedFile = await _picker.pickVideo(
//         source: ImageSource.gallery,
//         preferredCameraDevice: CameraDevice.rear,
//       );

//       if (pickedFile == null) {
//         print("No file selected");
//         return;
//       }

//       filePath = pickedFile.path;
//       print('Selected file path: $filePath');

//       // Check file size
//       final file = File(filePath!);
//       final fileSizeInBytes = await file.length();
//       final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

//       if (fileSizeInMB > 100) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('File size exceeds 100 MB.')),
//         );
//         return;
//       }

//       // Initialize video for local playback
//       if (filePath!.endsWith('.mp4')) {
//         _initializeVideo(filePath!);
//       }

//       // Upload the file
//       await _uploadFile(filePath!, context);
//     } catch (e) {
//       print("Error selecting or uploading file: $e");
//       _isFailed = true;
//       notifyListeners();
//     }
//   }

//   // void _initializeVideo(String filePath) {
//   //   _videoController?.dispose(); // Dispose the previous controller if it exists
//   //   _videoController = VideoPlayerController.file(File(filePath))
//   //     ..initialize().then((_) {
//   //       _videoController!.setLooping(true);
//   //       _videoController!.play();
//   //       notifyListeners();
//   //     }).catchError((error) {
//   //       print("Error initializing video player: $error");
//   //       _videoController = null;
//   //       notifyListeners();
//   //     });
//   // }
//   void _initializeVideo(String filePath) {
//     _videoController?.dispose();
//     _videoController = VideoPlayerController.file(File(filePath))
//       ..addListener(() {
//         print("Video controller state: ${_videoController?.value}");
//       })
//       ..initialize().then((_) {
//         print("Video initialized successfully.");
//         _videoController!.setLooping(true);
//         _videoController!.play();
//         videoController!.addListener(
//           () {
//             if (videoController!.value.isInitialized &&
//                 !videoController!.value.isPlaying) {
//               videoController!.play();
//             }
//             print("Video controller state: ${_videoController?.value}");
//           },
//         );
//         _initializeVideo(filePath);
//       }).catchError((error) {
//         print("Error initializing video player: $error");
//         _videoController = null;
//         notifyListeners();
//         notifyListeners();

//         notifyListeners();
//       }).catchError((error) {
//         print("Error initializing video player: $error");
//         _videoController = null;
//         notifyListeners();
//       });
//   }

//   Future<void> _uploadFile(String filePath, BuildContext context) async {
//     try {
//       _isUploading = true;
//       _isFailed = false;
//       _progress = 0.0;
//       notifyListeners();

//       print("Starting upload for file: $filePath");
//       final file = File(filePath);
//       final fileName = filePath.split('/').last;

//       // Firebase Storage Reference
//       final storageRef = FirebaseStorage.instance.ref('uploads/$fileName');
//       final uploadTask = storageRef.putFile(file);

//       // Monitor upload progress
//       uploadTask.snapshotEvents.listen((event) {
//         _progress = event.bytesTransferred / event.totalBytes;
//         notifyListeners();
//       });

//       await uploadTask.whenComplete(() {});
//       final downloadUrl = await storageRef.getDownloadURL();
//       print('File uploaded successfully. Download URL: $downloadUrl');

//       _isUploading = false;
//       notifyListeners();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('File uploaded successfully: $fileName')),
//       );
//     } catch (e) {
//       print("Upload failed: $e");
//       _isUploading = false;
//       _isFailed = true;
//       notifyListeners();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Upload failed. Please try again.')),
//       );
//     }
//   }

//   void retryUpload(BuildContext context) {
//     if (filePath != null) {
//       pickAndUploadFile(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No file selected to retry upload.')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }
// }

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class homescreencontroller with ChangeNotifier {
  double _progress = 0.0;
  bool _isUploading = false;
  bool _isFailed = false;
  String? filePath; // File path for the selected file
  VideoPlayerController? _videoController;
  UploadTask? _currentUploadTask;

  double get progress => _progress;
  bool get isUploading => _isUploading;
  bool get isFailed => _isFailed;
  VideoPlayerController? get videoController => _videoController;

  final ImagePicker _picker = ImagePicker();

  /// Picks and uploads a file
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

      // Check file size
      final file = File(filePath!);
      final fileSizeInBytes = await file.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB < 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File size must be at least 100 MB.')),
        );
        return;
      }

      // Initialize video for local playback if it's a video file
      if (filePath!.endsWith('.mp4')) {
        _initializeVideo(filePath!);
      }

      // Start the upload
      await _uploadFile(filePath!, context);
    } catch (e) {
      _isFailed = true;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error selecting or uploading file')),
      );
    }
  }

  /// Initializes the video for preview
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
  Future<void> _uploadFile(String filePath, BuildContext context) async {
    try {
      _isUploading = true;
      _isFailed = false;
      _progress = 0.0;
      notifyListeners();

      final file = File(filePath);
      final fileName = filePath.split('/').last;

      final storageRef = FirebaseStorage.instance.ref('uploads/$fileName');
      _currentUploadTask = storageRef.putFile(file);

      _currentUploadTask!.snapshotEvents.listen((event) {
        _progress = event.bytesTransferred / event.totalBytes;
        notifyListeners();
      });

      await _currentUploadTask!.whenComplete(() {});
      final downloadUrl = await storageRef.getDownloadURL();

      _isUploading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload successful: $downloadUrl')),
      );
    } catch (e) {
      _isUploading = false;
      _isFailed = true;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload failed. Please try again.')),
      );
    }
  }

  /// Retry uploading the last file
  void retryUpload(BuildContext context) {
    if (filePath != null) {
      pickAndUploadFile(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected to retry upload.')),
      );
    }
  }

  /// Disposes the controller
  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
