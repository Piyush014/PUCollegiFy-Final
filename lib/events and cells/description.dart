import 'package:flutter/material.dart';
class MyDescription extends StatefulWidget {
  final String name;
  final String eimage;
  final String eventDescription;
  final int edate;
  final String emonth;
  final String elocation;
  const MyDescription({required this.name, required this.eimage, required this.edate,required this.emonth,Key? key, required this.elocation,required this.eventDescription}) : super(key: key);

  @override
  State<MyDescription> createState() => _MyDescriptionState();
}

class _MyDescriptionState extends State<MyDescription> {
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
                child: Text(widget.name),
              ),
            ),
            flexibleSpace: Image.network(
              widget.eimage,
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
                    'Event Details:',
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
                            widget.eventDescription,
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
                    'Event Date:',
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
                          widget.edate.toString() + widget.emonth,
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
                    'Venue:',
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
                          widget.elocation,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Placeholder()));
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width*.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.lightBlueAccent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Register',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
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
