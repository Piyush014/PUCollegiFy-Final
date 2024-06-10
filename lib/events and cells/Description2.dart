import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class cellDescription extends StatefulWidget {
  final String cname;
  final String image;
  final String location;
  final String description;
  final String website;
  final String contact;
  const cellDescription({required this.cname, required this.image, required this.description, Key? key, required this.location, required this.website, required this.contact}) : super(key: key);

  @override
  State<cellDescription> createState() => _cellDescriptionState();
}

class _cellDescriptionState extends State<cellDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6ebec),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),),
          child: AppBar(
            title: Padding(
              padding: EdgeInsets.only(right: 45),
              child: Center(
                child: Text(widget.cname),
              ),
            ),
            flexibleSpace: Image.network(
              widget.image,
              fit: BoxFit.cover,
              height: 240,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
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
                            widget.description,
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
                      launch("tel:${widget.contact}");
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
                            widget.contact,
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
                          widget.location,
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
                      launch(widget.website);
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
                            widget.website,
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
