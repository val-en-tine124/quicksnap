// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:intl/intl.dart';
// import 'providers.dart';
// import 'models/entry.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final entriesAsync = ref.watch(entriesProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('QuickSnap'), centerTitle: true),
//       body: entriesAsync.when(
//         data: (entries) => entries.isEmpty
//             ? const Center(
//                 child: Text(
//                   'No memories yet ✨\nTap + to start',
//                   textAlign: TextAlign.center,
//                 ),
//               )
//             : ListView.builder(
//                 itemCount: entries.length,
//                 itemBuilder: (ctx, i) => EntryTile(entries[i]),
//               ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (_, _) => const Center(child: Text('Error loading data')),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddSheet(context, ref),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddSheet(BuildContext context, WidgetRef ref) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       builder: (_) => AddEntrySheet(ref: ref),
//     );
//   }
// }

// class EntryTile extends StatelessWidget {
//   final Entry entry;
//   const EntryTile(this.entry, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: ListTile(
//         title: Text(entry.text ?? 'Photo'),
//         subtitle: Text(
//           DateFormat('MMM d, yyyy – HH:mm').format(entry.createdAt),
//         ),
//         trailing: entry.photoPath != null ? const Icon(Icons.photo) : null,
//         onTap: entry.photoPath != null
//             ? () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => FullPhotoScreen(entry.photoPath!),
//                 ),
//               )
//             : null,
//         onLongPress: () => SnackBar(content: Text("Loading...")),
//       ),
//     );
//   }
// }

// class FullPhotoScreen extends StatelessWidget {
//   final String path;
//   const FullPhotoScreen(this.path, {super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(title: Text(path)),
//     body: Center(child: Image.file(File(path))),
//   );
// }

// class AddEntrySheet extends ConsumerStatefulWidget {
//   final WidgetRef ref;
//   const AddEntrySheet({required this.ref, super.key});

//   @override
//   ConsumerState<AddEntrySheet> createState() => _AddEntrySheetState();
// }

// class _AddEntrySheetState extends ConsumerState<AddEntrySheet> {
//   final textController = TextEditingController();

//   Future<void> _takePhoto() async {
//     final cameras = await availableCameras();
//     final camera = cameras.first;
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CameraScreen(camera: camera)),
//     );
//     if (result is String) {
//       await widget.ref.read(addEntryProvider)(
//         photoPath: result,
//         text: textController.text,
//       );
//       if (mounted) Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedPadding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       duration: const Duration(milliseconds: 200),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16),
//             child: Text(
//               'New memory',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: TextField(
//               controller: textController,
//               decoration: const InputDecoration(
//                 hintText: 'What’s on your mind?',
//               ),
//               maxLines: 4,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _takePhoto,
//                 icon: const Icon(Icons.camera_alt),
//                 label: const Text('Snap Photo'),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   await widget.ref.read(addEntryProvider)(
//                     text: textController.text,
//                   );
//                   if (mounted) Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.save),
//                 label: const Text('Save Text'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }

// class CameraScreen extends StatefulWidget {
//   final CameraDescription camera;
//   const CameraScreen({required this.camera, super.key});

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _controller.initialize().then((_) => setState(() {})).onError((e, _) {
//       SnackBar(
//         content: Text(
//           "An exception occurred $e",
//           style: TextStyle(color: Colors.red),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) return Container();
//     return Scaffold(
//       body: CameraPreview(_controller),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.camera),
//         onPressed: () async {
//           final dir = await getTemporaryDirectory();
//           final path =
//               '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//           await _controller.takePicture().then((xfile) => xfile.saveTo(path));
//           if (mounted) Navigator.pop(context, path);
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
