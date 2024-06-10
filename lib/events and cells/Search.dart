import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6ebec),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: CupertinoSearchTextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              searchInput = value.toLowerCase(); // Convert input to lowercase
            });
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: searchInput == ''
          ? Center(
        child: Text(
          'Search for any Cells you want!!',
          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Cell').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong!"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredDocs = snapshot.data!.docs.where((e) {
            final cellName = e['cellName'].toString().toLowerCase();
            return cellName.contains(searchInput);
          }).toList();

          if (filteredDocs.isEmpty) {
            return Center(
              child: Text(
                'No cells found for "$searchInput"',
                style: TextStyle(fontSize: 20, color: Colors.blueGrey),
              ),
            );
          }

          return ListView(
            children: filteredDocs.map((e) => CellWidget(e: e)).toList(),
          );
        },
      ),
    );
  }
}

class CellWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> e;

  CellWidget({
    required this.e,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the cellDescription screen when tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CellDescription(
              cname: e['cellName'],
              image: e['cellImage'],
              description: e['cellDescription'],
              location: e['cellLocation'],
              website: e['cellWebsite'],
              contact: e['cellContact'],
            ),
          ),
        );
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              height: 129,
              width: 800,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(13),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(e['cellImage']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 129,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                e['cellName'],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     Icon(
                          //       Icons.location_city,
                          //     ),
                          //     SizedBox(width: 10),
                          //     // Text(
                          //     //   e['cellWebsite'],
                          //     // ),
                          //   ],
                          // ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                              ),
                              SizedBox(width: 10),
                              Text(
                                e['cellLocation'],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CellDescription extends StatelessWidget {
  final String cname;
  final String image;
  final String location;
  final String description;
  final String website;
  final String contact;

  CellDescription({
    required this.cname,
    required this.image,
    required this.description,
    required this.location,
    required this.website,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6ebec),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          child: AppBar(
            title: Padding(
              padding: EdgeInsets.only(right: 45),
              child: Center(
                child: Text(cname),
              ),
            ),
            flexibleSpace: Image.network(
              image,
              fit: BoxFit.cover,
              height: 240,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Cell Details:',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 230,
                      width: 320,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            description,
                            style: TextStyle(
                              height: 1.5,
                              letterSpacing: 1.5,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  Text(
                    'Cell Contact',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      launch("tel:$contact");
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        height: 45,
                        width: 320,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            contact,
                            style: TextStyle(
                              letterSpacing: 1.5,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  Text(
                    'Venue',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 45,
                      width: 320,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          location,
                          style: TextStyle(
                            letterSpacing: 1.5,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  Text(
                    'Website',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      launch(website);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        height: 45,
                        width: 320,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            website,
                            style: TextStyle(
                              letterSpacing: 1.5,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}