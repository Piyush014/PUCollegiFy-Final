import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/foodStores/streamingFoodItems.dart';
import 'package:dummy/minor%20screens/userHomescreenBottomNavBar.dart';
import 'package:dummy/minor%20screens/searchbar.dart';
import 'package:flutter/material.dart';

import '../foodStores/food Store owners pages/streamFoodStores.dart';
import '../foodStores/foodStoreItemPage.dart';

class FoodOrder extends StatefulWidget {
  const FoodOrder({super.key});

  @override
  State<FoodOrder> createState() => _FoodOrderState();
}

class _FoodOrderState extends State<FoodOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe6ebec),
      appBar: AppBar(
        automaticallyImplyLeading:false ,
          elevation: 0,
          backgroundColor: Color(0xFF252525),
          title: FakeSearchBar()),
      body: StreamFoodStores(),
      );
  }
}

// class storeDetails extends StatelessWidget {
//   final String fsname;
//   final String location;
//   final String category;
//   final String image;
//   const storeDetails({required this.fsname,required this.category,required this.image,required this.location,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodStoreItemPage(fsname:fsname,image: image,)));
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: ClipRRect(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           child: Container(
//             color: Colors.white,
//             width: MediaQuery.of(context).size.width * .95,
//             height: 123,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                     child: Image.network(
//                       image,fit: BoxFit.cover,width: 150,height: 100,
//                     ),
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [Text(fsname)],
//                     ),
//                     SizedBox(height: 15,),
//                     Row(
//                       children: [Text(location)],
//                     ),
//                     SizedBox(height: 15,),
//
//                     Row(
//                       children: [Text(category)],
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

