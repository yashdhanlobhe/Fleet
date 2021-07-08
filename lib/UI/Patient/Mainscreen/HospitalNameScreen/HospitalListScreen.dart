import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/rounded_button.dart';
import 'HospitalWidgets.dart';



class HospitalListScreen extends StatefulWidget {
  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  late CollectionReference collectionReference;
  bool isDrawerOpen = false;


  @override
  Widget build(BuildContext context) {
    collectionReference = FirebaseFirestore.instance.collection("hospitals");

    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)..rotateY(isDrawerOpen? -0.5:0),
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(isDrawerOpen?40:0.0)
      ),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Colors.grey[200],
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isDrawerOpen?IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: (){
                          setState(() {
                            xOffset=0;
                            yOffset=0;
                            scaleFactor=1;
                            isDrawerOpen=false;
                          });
                        },

                      ): IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            setState(() {
                              xOffset = 220;
                              yOffset = 90;
                              scaleFactor = 0.8;
                              isDrawerOpen=true;
                            });
                          }),
                      Column(
                        children: [
                          Text('Location'),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: kPrimaryColor,
                              ),
                              Text('Kolhapur'),
                            ],
                          ),
                        ],
                      ),
                      CircleAvatar()
                    ],
                  ),
                ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  margin: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.search),
                      Text('Search Hospital'),
                      Icon(Icons.settings)
                    ],
                  ),
                ),
                HospitalList(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  HospitalList(BuildContext context) {
    return Container(
      child: getData(),
      height: MediaQuery.of(context).size.height - 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(48), topLeft: Radius.circular(48)),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 0),
            blurRadius: 15,
          ),
        ],
      ),
    );
  }

  static bool isPortrait(context) {
    if(MediaQuery.of(context).orientation == Orientation.portrait){
      return true;
    }
    return false;
  }

  getData() {
    return StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView(
                children: documents
                    .map((doc) => HospitalWidget(doc, collectionReference))
                    .toList());
          } else if (snapshot.hasError) {
            return Text("Something went wrong!");
          }
          return Text("Loading");
        });
  }

}

