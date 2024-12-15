// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:interview_task_sample/controller/home_screen_controller/home_screen_Controller.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Provider.of<homescreencontroller>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Media Uploader')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Show Video Player if Video is Initialized
//             if (controller.videoController != null &&
//                 controller.videoController!.value.isInitialized)
//               AspectRatio(
//                 aspectRatio: controller.videoController!.value.aspectRatio,
//                 child: VideoPlayer(controller.videoController!),
//               )

//             // Show a loading message while the video initializes
//             else if (controller.filePath != null &&
//                 controller.filePath!.endsWith('.mp4'))
//               const Center(child: Text("Video is loading..."))
//             // Show Image if Image is Selected
//             else if (controller.filePath != null &&
//                 (controller.filePath!.endsWith('.jpg') ||
//                     controller.filePath!.endsWith('.png') ||
//                     controller.filePath!.endsWith('.jpeg')))
//               Image.file(File(controller.filePath!)),
//             const SizedBox(height: 16),
//             // Show Upload Progress
//             if (controller.isUploading)
//               Column(
//                 children: [
//                   LinearProgressIndicator(value: controller.progress),
//                   Text('${(controller.progress * 100).toStringAsFixed(2)}%'),
//                   const SizedBox(height: 8),
//                   const Text('Uploading...'),
//                 ],
//               ),
//             // Retry Button if Upload Failed
//             if (controller.isFailed)
//               ElevatedButton(
//                 onPressed: () => controller.retryUpload(context),
//                 child: const Text('Retry Upload'),
//               ),
//             const SizedBox(height: 16),
//             // Button to Select and Upload File
//             Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey, width: 1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextButton(
//                   onPressed: () => controller.pickAndUploadFile(context),
//                   child: const Text(
//                     'Click here to Select and Upload File',
//                     style: TextStyle(color: Colors.black, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:interview_task_sample/controller/home_screen_controller/home_screen_Controller.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<homescreencontroller>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Media Uploader')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show Video Player if Video is Initialized
              if (controller.videoController != null &&
                  controller.videoController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: controller.videoController!.value.aspectRatio,
                  child: VideoPlayer(controller.videoController!),
                )
              // Show a loading message while the video initializes
              else if (controller.filePath != null &&
                  controller.filePath!.endsWith('.mp4'))
                const Center(child: Text("Video is loading..."))
              // Show Image if Image is Selected
              else if (controller.filePath != null &&
                  (controller.filePath!.endsWith('.jpg') ||
                      controller.filePath!.endsWith('.png') ||
                      controller.filePath!.endsWith('.jpeg')))
                Image.file(File(controller.filePath!)),
              const SizedBox(height: 16),

              // Show Upload Progress
              if (controller.isUploading)
                Column(
                  children: [
                    LinearProgressIndicator(value: controller.progress),
                    Text('${(controller.progress * 100).toStringAsFixed(2)}%'),
                    const SizedBox(height: 8),
                    const Text('Uploading...'),
                  ],
                ),

              // Retry Button if Upload Failed
              if (controller.isFailed)
                ElevatedButton(
                  onPressed: () => controller.retryUpload(context),
                  child: const Text('Retry Upload'),
                ),

              const SizedBox(height: 16),

              // Button to Select and Upload File
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () => controller.pickAndUploadFile(context),
                    child: const Text(
                      'Click here to Select and Upload File',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
