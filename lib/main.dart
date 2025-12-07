import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/providers.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
      home: HomePage(),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Valentine's QuickSnap")),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(countProvider.notifier).state++;
        },
        tooltip: "Increment counter",
        child: const Icon(Icons.add),
      ),
      body: const HomePageBody(),
    );
  }
}

class HomePageBody extends ConsumerWidget {
  const HomePageBody({super.key});
  
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Center(child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("The Current Counter Value is ${ref.watch(countProvider)} "),
      ],
    ));
  }
}
