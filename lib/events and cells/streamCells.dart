import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Description2.dart';

class StreamCell extends StatefulWidget {
  const StreamCell({super.key});

  @override
  State<StreamCell> createState() => _StreamCellState();
}

class _StreamCellState extends State<StreamCell> {
  final Stream<QuerySnapshot> cellStream =
  FirebaseFirestore.instance.collection('Cell').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: cellStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong!');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;

            return cellDetails(
              context,
              data['cellName'] ?? '',
              data['cellImage'] ?? '',
              data['cellLocation'] ?? '',
              data['cellDescription'] ?? '',
              data['cellWebsite'] ?? '',
              data['cellContact'] ?? '',
            );

          }).toList(),
        );
      },
    );
  }

  GestureDetector cellDetails(
      BuildContext context,
      final String cname,
      final String image,
      final String location,
      final String description,
      final String website,
      final String contact,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => cellDescription(
            cname: cname,
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
                              image: NetworkImage(image),
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
                            Flexible(
                              child: Text(
                                cname,maxLines: 1,overflow: TextOverflow.ellipsis,
                              ),
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
                            Flexible(
                              child: Text(
                                location,
                                maxLines: 1,overflow: TextOverflow.ellipsis,
                              ),
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
    );
  }
}
