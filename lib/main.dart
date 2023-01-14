import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan your duties'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 83, 196, 183),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance.collection('categories').add(
            {
              'title': 'Super kategoria',
            },
          );
        },
        backgroundColor: const Color.fromARGB(255, 30, 195, 115),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('An unexpected problem occured');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Please wait, the app is loading data');
            }

            final documents = snapshot.data!.docs;

            return ListView(
              children: [
                for (final document in documents) ...[
                  Dismissible(
                      key: ValueKey(document.id),
                      onDismissed: (_) {
                        FirebaseFirestore.instance
                            .collection('categories')
                            .doc(document.id)
                            .delete();
                      },
                      child: CategoryWidget(document['title'])),
                ],
              ],
            );
          }),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 147, 227, 227),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(18),
      child: Text(title),
    );
  }
}
