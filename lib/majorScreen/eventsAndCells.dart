import 'package:dummy/minor%20screens/searchbar.dart';
import 'package:flutter/material.dart';
import '../events and cells/Search.dart';
import '../events and cells/description.dart';
import '../events and cells/streamCells.dart';
import '../events and cells/streamEvents.dart';

class EventAndCells extends StatefulWidget {
  const EventAndCells({super.key});

  @override
  State<EventAndCells> createState() => _EventAndCellsState();
}

class _EventAndCellsState extends State<EventAndCells> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: Color(0xffe6ebec),
        appBar: AppBar(
          backgroundColor: Color(0xff252525),
          title: SearchBar(),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Events'), // First tab label
              Tab(text: 'Cells'),  // Second tab label
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamEvent(), // First tab content
            StreamCell(),  // Second tab content
          ],
        ),
      ),
    );
  }

}

class SearchBar extends StatefulWidget {
  SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  int color=0xFF98e8e8;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Search()));
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Color(color))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [Icon(
                Icons.search,
                color: Colors.grey.shade600,
              ),
                Text(
                  'What are you looking for?',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
                )],),
            ),
            Container(
              height: 32,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),color: Color(color),),
              child: Center(child: Text('Search',style: TextStyle(color: Colors.grey),)),
            )
          ],
        ),
      ),
    );;
  }
}