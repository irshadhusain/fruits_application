import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 50,
                                        width: 50,
                                        color: Colors.amber,
                                        child: CachedNetworkImage(
                                          height: 100,
                                          width: 100,
                                          imageUrl:
                                              documentSnapshot['imageUrl'],
                                          //_imageUrls != null ? _imageUrls[index] : "",
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          documentSnapshot['productName']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          documentSnapshot['calarie'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          documentSnapshot['foodTakenTime'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          child: const Icon(Icons.edit),
                                          onTap: () {
                                            _update(documentSnapshot);
                                          },
                                        ),
                                        const SizedBox(
                                          width: 18,
                                        ),
                                        InkWell(
                                          child: const Icon(Icons.delete),
                                          onTap: () {
                                            _delete(documentSnapshot.id);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ]),
                    ),
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
