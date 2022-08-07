import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';

class Spacecraft {
  final String id;
  final String name, imageUrl, propellant;

  Spacecraft({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.propellant,
  });

  factory Spacecraft.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft(
      id: jsonData['id'],
      name: jsonData['name'],
      propellant: jsonData['propellant'],
      imageUrl: jsonData['imageurl'],
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Spacecraft> spacecrafts;

  CustomListView(this.spacecrafts);

  Widget build(context) {
    return ListView.builder(
      itemCount: spacecrafts.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(spacecrafts[currentIndex], context);
      },
    );
  }

  Widget createViewItem(Spacecraft spacecraft, BuildContext context) {
    return new ListTile(
        title: new Card(
          elevation: 5.0,
          child: new Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.orange,)),
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  child: Image.network(spacecraft.imageUrl),
                  padding: EdgeInsets.only(bottom: 8.0),
                ),
                Row(children: <Widget>[
                  Padding(
                      child: Text(
                        spacecraft.name,
                        style: new TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),
                  Text(" | "),
                  Padding(
                      child: Text(
                        spacecraft.propellant,
                        style: new TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),
                ]),
              ],
            ),
          ),
        ),
        onTap: () {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
            new SecondScreen(value: spacecraft, key: Key("value"),),
          );

          Navigator.of(context).push(route);
        });
  }
}

Future<List<Spacecraft>> downloadJSON() async {
  final jsonEndpoint =
      "https://raw.githubusercontent.com/johnriad/hot-dog/main/hot%20dog.json";

  final response = await get(Uri.parse(jsonEndpoint));

  if (response.statusCode == 200) {
    List spacecrafts = json.decode(response.body);
    return spacecrafts
        .map((spacecraft) => new Spacecraft.fromJson(spacecraft))
        .toList();
  } else
    throw Exception('We were not able to successfully download the json data.');
}

class SecondScreen extends StatefulWidget {
  final Spacecraft value;

  SecondScreen({required Key key, required this.value}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late Timer timer;
  var value = 0;
  var values = 0;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Detail Page')),
      body: new Container(
        child: new Center(
          child: Column(
            children: <Widget>[
              Padding(
                child: new Text(
                  'FOOD DETAILS',
                  style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              Padding(
                child: Image.network( '${widget.value.imageUrl}'),
                padding: EdgeInsets.only(bottom: 8.0),
              ),
              Padding(
                child: new Text(
                  'NAME : ${widget.value.name}',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.all(20.0),
              ),
              Padding(
                child: new Text(
                  'PRICE : ${widget.value.propellant}',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.all(20.0),
              ),
              // item add system start here ------------
              Padding(
                child: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    print('ADD + ');

                    setState(() {
                      value++;
                    });
                    print('ADD +  $value');

                  },
                  child: Container(
                    height: 40,
                    width: 230,
                    color: Colors.amber,
                    child: Center(
                        child: Text(
                          'ITEM ADD + $value',
                          style: TextStyle(fontSize: 25),
                        )),
                  ),
                ),
                padding: EdgeInsets.all(5.0),
              ),

              // Second item system------------

              Padding(
                child: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    print('sub');
                    setState(() {
                      value--;
                    });
                    print('ITEM SUB - $value');
                  },
                  child: Container(
                    height: 40,
                    width: 230,
                    color: Colors.amber,
                    child: Center(
                        child: Text(
                          'ITEM SUB -  ',
                          style: TextStyle(fontSize: 25),
                        )
                    ),
                  ),
                ),
                padding: EdgeInsets.all(0.0),
              ),

/* create add to cart---------*/

              Padding(
                child: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("ADD CART SUCCESSFULLY ....."),
                    ));
                  },
                  child: Container(
                    height: 30,
                    width: 130,
                    color: Colors.amber,
                    child: Center(
                      child: Text("ADD To CART",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                padding: EdgeInsets.all(5.0),
              ),
/* end of item system */
            ],
          ),
        ),
      ),
    );
  }
}

class Three extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: const Text('Riad Food Corner'),
        ),
        body: new Center(
          child: new FutureBuilder<List<Spacecraft>>(
            future: downloadJSON(),

            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Spacecraft> spacecrafts = snapshot.data!;
                return new CustomListView(spacecrafts);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return new CircularProgressIndicator();
            },
          ),

        ),
      ),
    );
  }
}

void main() {
  runApp(Three());
}
