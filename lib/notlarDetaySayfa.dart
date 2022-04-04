import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


import 'main.dart';
import 'notlar.dart';

class NotDetaySayfa extends StatefulWidget {

  Notlar not;

  NotDetaySayfa({ required this.not});


  @override
  State<NotDetaySayfa> createState() => _NotDetaySayfaState();
}

class _NotDetaySayfaState extends State<NotDetaySayfa> {

  var refTest = FirebaseDatabase.instance.ref().child("notlar");
  var tfDersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();


  Future<void> sil() async
  {
    //await Notlardao().notSil(not_id);

    refTest.child(widget.not.not_id).remove();

    print('Ders silindi: ${widget.not.not_id}');
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }


  Future<void> guncelle() async
  {

    var bilgi = HashMap<String, dynamic> ();
    bilgi ["ders_adi"] = tfDersAdi.text;
    bilgi ["not1"] = int.parse(tfNot1.text);
    bilgi ["not2"] = int.parse(tfNot2.text);

    refTest.child(widget.not.not_id).update(bilgi);

   // await Notlardao().notGuncelle(not_id, dersAdi, not1, not2);
   // print('Ders adı: $dersAdi, Not 1: $not1, Not 2: $not2 güncellendi.');
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tfDersAdi.text = widget.not.ders_adi;
    tfNot1.text = widget.not.not1.toString();
    tfNot2.text = widget.not.not2.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Not Detay"),
        actions: [
          TextButton(onPressed: ()
          {
           sil();
          }, child: Text("Sil",style: TextStyle(color: Colors.white),)),

          TextButton(onPressed: ()
          {
           guncelle();
          }, child: Text("Güncelle",style: TextStyle(color: Colors.white))),
        ],
      ),
      body: Center(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0,right: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                TextField(
                  controller: tfDersAdi,
                  decoration: InputDecoration(hintText: "Ders Adı"),

                ),

                TextField(
                  controller: tfNot1,
                  decoration: InputDecoration(hintText: "1. Not"),
                ),

                TextField(
                  controller: tfNot2,
                  decoration: InputDecoration(hintText: "2. Not"),
                ),


              ],
            ),
          ),
        ),
      ),



    );
  }
}