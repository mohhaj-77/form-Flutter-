
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './ek sayfalar/bil_ekle.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'form',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// text fields' controllers
  final TextEditingController _adController = TextEditingController(); 
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _telController = TextEditingController(); 

  final CollectionReference _form =
      FirebaseFirestore.instance.collection('form'); //database ile ilişki kurması

  Future<void> _olustur([DocumentSnapshot? documentSnapshot]) async {

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
                  controller: _adController,
                  decoration: const InputDecoration(labelText: 'ad'),
                ),
                TextField(
                  controller: _soyadController,
                  decoration: const InputDecoration(labelText: 'soyad'),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  controller: _telController,
                  decoration: const InputDecoration(
                    labelText: 'tel',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String ad = _adController.text;
                    final String soyad = _soyadController.text;
                    final double? tel =
                    double.tryParse(_telController.text);
                    if (tel != null) {
                        await _form.add({"ad": ad, "soyad": soyad,"tel":tel });

                      _adController.text = '';
                      _soyadController.text = '';
                      _telController.text = '';
                        Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );

        });
  }
  Future<void> _duzeltme([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {

      _adController.text = documentSnapshot['ad'];
      _soyadController.text = documentSnapshot['soyad'];
      _telController.text = documentSnapshot['tel'].toString();
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
                  controller: _adController,
                  decoration: const InputDecoration(labelText: 'ad'),
                ),
                TextField(
                  controller: _soyadController,
                  decoration: const InputDecoration(labelText: 'soyad'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _telController,
                  decoration: const InputDecoration(
                    labelText: 'tel',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text( 'duzelt'),
                  onPressed: () async {
                    final String ad = _adController.text;
                    final String soyad = _soyadController.text;
                    final double? tel =
                        double.tryParse(_telController.text);
                    if (tel != null) {

                        await _form
                            .doc(documentSnapshot!.id)
                            .update({"ad": ad, "soyad": soyad, "tel": tel});
                      _adController.text = '';
                      _soyadController.text = '';
                      _telController.text = '';
                        Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _sil(String productId) async {
    await _form.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('bilgiler silindiler')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('form')),
        backgroundColor: Color.fromARGB(255, 110, 209, 113),
        centerTitle:true,
        foregroundColor: Color.fromARGB(255, 60, 139, 36),

        
      ),
      body: StreamBuilder(
        stream: _form.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =  
                    streamSnapshot.data!.docs[index];
                return Card(                  
                  margin: const EdgeInsets.all(10),
                     child: ListTile(
                    title: Text(documentSnapshot['ad']),
                    subtitle: Text(documentSnapshot['tel'].toString()),
                    trailing: SizedBox(
                      width: 170,
                      child: Row(
                        children: [
                          
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _duzeltme(documentSnapshot)),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _sil(documentSnapshot.id)),

                                   ElevatedButton(
				                           style: ButtonStyle(
					                         backgroundColor: MaterialStateProperty.all(Colors.green),
					                         padding:
						                      MaterialStateProperty.all(const EdgeInsets.all(5)),
				                       	textStyle: MaterialStateProperty.all(
						                   const TextStyle(fontSize: 17, color: Colors.white))),
				onPressed: () {
				 Navigator.push(context, MaterialPageRoute(builder: (context)=>Bil_ekle()),);
				},
				child: const Text('gir')),

                                   
                                   
                        ],
                      ),
                    ),
                    
                  ),
                   
                );
                

              },
              
            );


          }
         
          return const Center(
            child: CircularProgressIndicator(color: Color.fromARGB(255, 165, 221, 157),),
            
          );
         
       
			
        },
      ),
 

      floatingActionButton: FloatingActionButton(
        onPressed: () => _olustur(),
        child: const Icon(Icons.add, color: Color.fromARGB(255, 161, 236, 164),),
  
      ),
      
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}

