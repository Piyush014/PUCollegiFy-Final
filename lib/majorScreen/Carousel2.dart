import 'package:flutter/material.dart';

class Carousel2 extends StatefulWidget {
  const Carousel2({
    Key? key,
  }) : super(key: key);

  @override
  State<Carousel2> createState() => _CarouselState2();
}

class _CarouselState2 extends State<Carousel2> {
  final String name = 'Tech Expo';
  final String eimage = 'assets/images/img_8.jpg'; // Assuming the image is in the 'assets' directory
  final String eventDescription =
      " A project exhibition for the students from Degree and Diploma Engineering, Applied Science, Computer Application, and Agriculture.";
  final int edate = 06;
  final String emonth = ' February, 2024';
  final String elocation = 'Near Design Building';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6ebec),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(220), // Adjust the height as needed
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff252525),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            image: DecorationImage(
              image: AssetImage(eimage),
              fit: BoxFit.cover,
            ),
          ),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0, // Remove the elevation to make it flat
            title: Text(
              'Tech Expo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
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
                    'Event Details:',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 230,
                      width: MediaQuery.of(context).size.width - 50,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            eventDescription,
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
                      width: MediaQuery.of(context).size.width - 50,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          edate.toString() + emonth,
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
                      width: MediaQuery.of(context).size.width - 50,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          elocation,
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
