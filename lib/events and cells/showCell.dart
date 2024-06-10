import 'package:flutter/material.dart';
import 'Cell_Admin.dart';
import 'Description2.dart';
import 'streamCells.dart';

class sell extends StatefulWidget {
  const sell({super.key});

  @override
  State<sell> createState() => _sellState();
}

class _sellState extends State<sell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6ebec),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff252525),
        elevation: 0,
        title: Center(
          child: Text('Cell'),
        ),
      ),
      body: StreamCell(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Cells_admin()));
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xff252525),
      ),
    );
  }
}
class Cell_Info extends StatelessWidget {
  final String name;
  final String image;
  final String location;
  final String description;
  final String website;
  final String contact;


  const Cell_Info({
    required this.name,
    required this.image,
    required this.location,
    required this.description,
    required this.contact,
    required this.website,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return cellDetails(context);
  }

  GestureDetector cellDetails(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => cellDescription(
            cname: name,
            image: image,
            description: description,
            location: location,
            website: website,
            contact: contact,
          ),
        ));
      },
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
                              image: AssetImage(image),
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
                              name,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_city,
                            ),
                            SizedBox(width: 10),
                            Text(
                              website,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                            ),
                            SizedBox(width: 10),
                            Text(
                              location,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 41,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}