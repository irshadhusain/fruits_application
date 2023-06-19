import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fruits_applicatiopn/storage_service.dart';

class UserAddedProducts extends StatefulWidget {
  const UserAddedProducts({super.key});

  @override
  State<UserAddedProducts> createState() => _UserAddedProductsState();
}

class _UserAddedProductsState extends State<UserAddedProducts> {
  String? images;

  List<String> _imageUrls = [];
  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<String> getImagePath(
    String imagePath,
    String imageUrl,
  ) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child('$imagePath$imageUrl');
    String downloadURL = await storageRef.getDownloadURL();
    print("${downloadURL}");
    return downloadURL;
  }

  Future<void> _loadImages() async {
    try {
      final ListResult result = await storage.ref().child('test/').listAll();
      final List<String> urls = [];
      for (final Reference ref in result.items) {
        final String url = await ref.getDownloadURL();
        urls.add(url);
      }
      setState(() {
        _imageUrls = urls;
        print("List Of Image ${urls}");
      });
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  // Future<void> uploadFile(String filePath, String fileName) async {
  //   File file = File(filePath);
  //   try {
  //     await storage
  //         .ref(
  //             'test/data/user/0/com.example.fruits_applicatiopn/cache/file_picker/$fileName')
  //         .putFile(file);
  //   } on firebase_core.FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _calarieController = TextEditingController();
  final TextEditingController _foodTakenTimeController =
      TextEditingController();
  final CollectionReference _product =
      FirebaseFirestore.instance.collection('product');

  final storage = FirebaseStorage.instance;
  final Storage storage1 = Storage();

  @override
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
                ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg'],
                      );
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("no file selected")));
                        return null;
                      }
                      final path = result.files.single.path;
                      final fileName = result.files.single.name;
                      getImagePath(
                        path!,
                        fileName,
                      );
                      images = fileName;
                      storage1.uploadFile(path!, fileName).then(
                          (value) => print('Irshad *********${fileName}'));
                      // _loadImages();
                      print('ImageUrl ********* ${images}');
                    },
                    child: const Text("Upload Image")),
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
                  height: 14,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Add Products'),
                  onPressed: () async {
                    final String name = _productNameController.text;
                    final String calarie = _calarieController.text;
                    final String foodTakenTime = _foodTakenTimeController.text;
                    if (calarie != null) {
                      await _product.add({
                        "productName": name,
                        "calarie": calarie,
                        "foodTakenTime": foodTakenTime,
                        "imageUrl": "$images",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _product.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
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
                          // Container(
                          //   child: Image.network(
                          //     _imageUrls != null ? _imageUrls[index] : "",
                          //     height: 40,
                          //     width: 40,
                          //   ),
                          // ),
                          Container(
                              height: 50,
                              width: 50,
                              color: Colors.amber,
                              child: CachedNetworkImage(
                                height: 100,
                                width: 100,
                                imageUrl: documentSnapshot['imageUrl'],
                                //_imageUrls != null ? _imageUrls[index] : "",
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            documentSnapshot['productName'].toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
    );
  }
}
