import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';










class Bil_ekle extends StatelessWidget {
const Bil_ekle({ Key? key}) : super(key: key);




  @override
  
  Widget build(BuildContext context) {
    String istapped = '';

 final TextEditingController _adController = TextEditingController(); 
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _telController = TextEditingController(); 

  final CollectionReference _form =
      FirebaseFirestore.instance.collection('form');


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




    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Color.fromARGB(255, 110, 209, 113),
        centerTitle:true,
        title: Text("bilgilerin ekle"),
        foregroundColor: Color.fromARGB(255, 60, 139, 36),

        ),
       body:Center(
        child: Column(
          children: [
         Text("adı"),
         TextField(
          controller: _adController,
               decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter your Phone Number"
               ),
       ),
         SizedBox(width: double.infinity, height: 50,),

         Text("soyadı"),
         TextField(   
          controller: _soyadController,
          decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter your Phone Number"
          ),),
         SizedBox(width: double.infinity, height: 50,),

         Text("numarası"),
         TextField(
          controller: _telController,
          decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter your Phone Number"
          ),),
         SizedBox(width: double.infinity, height: 50,),

         const SizedBox(
			height: 20,
			),

			// ElevatedButton
			ElevatedButton(
				style: ButtonStyle(
					backgroundColor: MaterialStateProperty.all(Colors.green),
					padding:
						MaterialStateProperty.all(const EdgeInsets.all(20)),
					textStyle: MaterialStateProperty.all(
						const TextStyle(fontSize: 14, color: Colors.white))),
				onPressed: ()  => _olustur(),
				child: const Text('bilgileri giriş')),
			const SizedBox(height: 20),
			Text(
			istapped,
			textScaleFactor: 2,
			)


        ],
        
             
        
       ),
       )

    ),

  );
}
}
 
