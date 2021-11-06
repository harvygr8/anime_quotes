import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'quote.dart';

void main() => runApp(PlaygroundApp());


class PlaygroundApp extends StatefulWidget {
  @override
  _PlaygroundAppState createState() => _PlaygroundAppState();
}

class _PlaygroundAppState extends State<PlaygroundApp> {


  final url = "https://animechan.vercel.app/api/quotes/anime?title=";
  Map mapResponse = {};
  List<AnimeQuote> listResponse = <AnimeQuote>[];
  String name="naruto";
  TextEditingController aName = TextEditingController();

  Future fetchFacts() async{
    listResponse.clear();
    Response res;
    res = await get(Uri.parse(url+name));
    if(res.statusCode==200){
      setState(() {
        print(json.decode(res.body));
        var jsonData = json.decode(res.body);
        for(var u in jsonData){
          AnimeQuote animeQuote = AnimeQuote(animeChar: u['character'] ,quoteText:u['quote']);
          listResponse.add(animeQuote);
        };
        return
        print(listResponse);
      });
    }
  }

  @override
  void initState() {
    fetchFacts();
    super.initState();
  }

  Widget factTemplate(quote,char){
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.blueAccent,
      child:Column(
        children:[
          Expanded(
            child: Container(
            width: 362,
            margin: EdgeInsets.all(15),
            child: Center(
              child: SelectableText(
                '"'+'${quote}'+'"'+"\n-"+"${char}",
                style:GoogleFonts.sriracha(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:
          Row(
            children: [
              Icon(Icons.class__outlined),
              SizedBox(width:7),
              Text(
                  "Anime Explorer",
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
            children:<Widget>[
              Column(
                children:<Widget>[
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: TextField (
                      //autofocus: true,
                      enabled: true,
                      cursorColor: Colors.white,
                      controller: aName,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        enabledBorder:OutlineInputBorder(
                          borderSide:BorderSide(
                            color:Colors.blueAccent,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:BorderSide(
                            color:Colors.blueAccent,
                            width: 2.0,
                          ),
                        ),
                        labelText: 'Enter an Anime name',
                        labelStyle: GoogleFonts.sriracha(
                          color:Colors.blueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: '',
                        hintStyle:TextStyle(color:Colors.black),
                      ),
                    ),
                    ),
                  ElevatedButton(
                      style:ElevatedButton.styleFrom(
                        primary:Colors.blueAccent,
                      ),
                      onPressed: (){
                        setState(() {
                          name=aName.text;
                          fetchFacts();
                        });
                      }, child:Text(
                          "Search Quotes",
                          style:GoogleFonts.sriracha(
                            fontSize: 15,
                          ),
                    )
                  ),
                ],
              ),
              SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: listResponse.length,
                  itemBuilder: (context,i){
                    return factTemplate(listResponse[i].quoteText.toString(),listResponse[i].animeChar.toString());
                    },
                ),
              ),
            ],
          ),
        ),
    );
  }
}
