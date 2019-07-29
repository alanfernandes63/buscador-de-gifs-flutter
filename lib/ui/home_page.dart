import 'dart:convert';

import 'package:buscador_de_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;
  Future<Map> _getGifs() async{

    http.Response response;

    if(_search == null)
      response = await http.get("add url and your key of api gif");
    else
      response = await http.get("add url and your key of api gif");
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGifs().then((map){
      print("teste $map");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: (OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,width: 2.0)
                )),
                  labelText: "Pesquise Aqui!",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  ),
              ),
              style: TextStyle(color: Colors.white,fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context,snatpshot){
                  switch(snatpshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0
                        ),
                      );
                      default:
                        if(snatpshot.hasError) return Container();
                        else return _createGifTable(context,snatpshot);
                  }
                }),
          ),
        ],
      ),
    );
  }
  Widget _createGifTable(BuildContext context,AsyncSnapshot snapshot){
  return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context,index){
        if(_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
            height: 300.0,
            fit: BoxFit.cover,),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index])));
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        }else{
          return Container(
            child: GestureDetector(
              child: Column(
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white,size: 70.0,),
                  Text("Carregar Mais...",
                  style: TextStyle(color: Colors.white,fontSize: 22.0),)
                ],
              ),
              onTap: (){
                setState(() {
                  _offset+=19;
                });
              },
            ),
          );
        }
      });
  }

  int _getCount( List data){
    if(_search == null || _search.isEmpty) return data.length;
    else return data.length + 1;
  }
}
