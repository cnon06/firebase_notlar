import 'dart:collection';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'NotKayitSayfa.dart';
import 'notlar.dart';
import 'notlarDetaySayfa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  var refTest = FirebaseDatabase.instance.ref().child("notlar");

  Future <void> kisiListele() async
  {
    await  refTest.onValue.listen((event){
      var gelenDegerler = event.snapshot.value as dynamic;

      if(gelenDegerler != null)
      {
        final _resultList = Map<String, dynamic>.from(gelenDegerler as LinkedHashMap);
        for (var key in _resultList.keys) {
          Map<String, dynamic> map2 = Map.from(_resultList[key]);
          print('${map2["ders_adi"]}, ${map2["not1"]}, ${map2["not2"]}');
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //kisiListele();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notlar"),
      ),
      body: WillPopScope(
        onWillPop: ()
    {
      return exit(0);
    },
    child: StreamBuilder<DatabaseEvent>(
      stream : refTest.onValue,
    builder: (context,event)
    {
    if(event.hasData)
    {
      List? notListesi = <Notlar>[];
      var gelenDegerler = event.data!.snapshot.value as dynamic;

      if(gelenDegerler != null)
      {
        final _resultList = Map<String, dynamic>.from(gelenDegerler as LinkedHashMap);
        for (var key in _resultList.keys) {

          Map<String, dynamic> map2 = Map.from(_resultList[key]);
          notListesi.add(Notlar(key,map2["ders_adi"],map2["not1"],map2["not2"]));
         // '${map2["ders_adi"]}, ${map2["not1"]}, ${map2["not2"]}'
        }
      }


    //var notListesi = event.data;
    return ListView.builder(

    itemCount:notListesi.length,
    itemBuilder: (context,indeks)
    {
    var notlar = notListesi[indeks];
    return GestureDetector(
    onTap: ()
    {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotDetaySayfa(not: notlar)));
    },
    child: SizedBox(
    height: 60,
    child: Card(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Text(notlar.ders_adi, style: TextStyle(fontWeight: FontWeight.bold),),
    Text("${notlar.not1}"),
    Text("${notlar.not2}"),
    ],
    ),
    ),
    ),
    );
    });
    }
    else return Center();
    },

    ),
    ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Not Ekle",
        child: Icon(Icons.add),
        onPressed: ()
        {
       Navigator.push(context, MaterialPageRoute(builder: (context) => NotKayitSayfa()));
        },

      ),
    );
  }
}
