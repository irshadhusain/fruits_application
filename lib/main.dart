import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fruits_applicatiopn/login_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Check Firebase connection status
  FirebaseApp firebaseApp = Firebase.app();
  bool isConnected = firebaseApp != null;
  print('${isConnected} FIREBASE CONNECTED');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      //  const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _calarieController = TextEditingController();
  final TextEditingController _foodTakenTimeController =
      TextEditingController();
  final CollectionReference _product =
      FirebaseFirestore.instance.collection('product');
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _productNameController.text = documentSnapshot['productName'];
      _calarieController.text = documentSnapshot['calarie'].toString();
      _foodTakenTimeController.text =
          documentSnapshot['foodTakenTime'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _productNameController,
                  decoration: const InputDecoration(labelText: 'ProductName'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _calarieController,
                  decoration: const InputDecoration(
                    labelText: 'Calarie',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _foodTakenTimeController,
                  decoration: const InputDecoration(
                    labelText: 'FoodTakenTime',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String productName = _productNameController.text;
                    final String calarie = _calarieController.text;
                    final String foodTakenTime = _foodTakenTimeController.text;

                    if (calarie != null) {
                      await _product.doc(documentSnapshot!.id).update({
                        "productName": productName,
                        "calarie": calarie,
                        "foodTakenTime": foodTakenTime
                      });
                      _productNameController.text = '';
                      _calarieController.text = '';
                      _foodTakenTimeController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _productNameController,
                  decoration: const InputDecoration(labelText: 'ProductName'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _calarieController,
                  decoration: const InputDecoration(
                    labelText: 'Calarie',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _foodTakenTimeController,
                  decoration: const InputDecoration(
                    labelText: 'FoodTakenTime',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String name = _productNameController.text;
                    final String calarie = _calarieController.text;
                    final String foodTakenTime = _foodTakenTimeController.text;
                    if (calarie != null) {
                      await _product.add({
                        "productName": name,
                        "calarie": calarie,
                        "foodTakenTime": foodTakenTime
                      });

                      _productNameController.text = '';
                      _calarieController.text = '';
                      _foodTakenTimeController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _product.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Container(
      //   child: Center(
      //     child: Text(
      //       "data",
      //       style: TextStyle(
      //           fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      //     ),
      //   ),
      // ),
      body: StreamBuilder(
          stream: _product.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                documentSnapshot['productName'].toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                width: 200,
                              ),
                              InkWell(
                                child: const Icon(Icons.edit),
                                onTap: () {
                                  _update(documentSnapshot);
                                },
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              InkWell(
                                child: const Icon(Icons.delete),
                                onTap: () {
                                  _delete(documentSnapshot.id);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Text(
                            documentSnapshot['calarie'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Text(
                            documentSnapshot['foodTakenTime'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ]),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            _create();
          },
          child: const Center(
            child: Text(
              'Add New Product',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _create(),
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
