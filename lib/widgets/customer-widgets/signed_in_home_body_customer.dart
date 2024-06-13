import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/models/category.dart';
import 'package:athlete_factory/models/sport.dart';
import 'package:athlete_factory/models/user.dart';
import 'package:flutter/material.dart';
import '../../functions/platform-type.dart';
import '../../services/database.dart';
import '../../config.dart';
import '../services-slider.dart';

IntrinsicHeight signedInHomeBodyCustomer(BuildContext context, CustomerUser customer){

  return IntrinsicHeight(
    child: Container(
      margin: const EdgeInsets.all(20),
      child: FutureBuilder(
        future: Future.wait([sportsData(), categoriesData(), userAccountsData(), mentorAccountsData()]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Container(
                  margin: EdgeInsets.only(top: (screenHeight(context) / 2) - AppBar().preferredSize.height),
                  child: Center(child: CircularProgressIndicator(color: Config.secondaryColor,))
              );
            }
            else if(snapshot.hasData){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  servicesSlider(context),
                  const SizedBox(height: 30,),
                  Text(" Top Mentorship Services", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.normal, fontSize: isDesktop(context)?26:22,),),
                  mentorshipServicesList(context, snapshot, customer),
                  Text(" Top Sports", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.normal, fontSize: isDesktop(context)?26:22,),),
                  sportsList(context, snapshot, customer),
                ],
              );
            }
          }
          return Container(
              margin: EdgeInsets.only(top: (screenHeight(context) / 2) - AppBar().preferredSize.height),
              child: Center(child: CircularProgressIndicator(color: Config.secondaryColor,))
          );
        },
      ),
    ),
  );
}

Widget mentorshipServicesList(BuildContext context, AsyncSnapshot<dynamic> snapshot, CustomerUser customer){

  List<dynamic> topCategories = snapshot.data[1]['top-categories'];

  return Container(
    margin: const EdgeInsets.only(top: 30,bottom: 30,),
    width: screenWidth(context),
    height: 50,
    child: ListView.builder(
        itemCount: topCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          return Container(
            margin: const EdgeInsets.only(right: 15),
            child: Card(
              elevation: 4,
              surfaceTintColor: Config.textFieldColor,
              color: Colors.grey[100],
              child: IntrinsicWidth(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: TextButton(
                    onPressed: (){
                      UserClass.refreshing = false;
                      CategoryClass.setCategoryInfo(snapshot, topCategories, index, customer);
                      Navigator.pushNamed(context, '/mentors-in-category');
                    },
                    child: Center(child: Text('${snapshot.data[1]['${topCategories[index]}']['category-name']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
  );
}

Widget sportsList(BuildContext context, AsyncSnapshot<dynamic> snapshot, CustomerUser customer){

  String leading = customer.getGender() == "Male"?"":"Women ";
  List<dynamic> topSports = snapshot.data[0][customer.getGender() == "Male"?'top-sports':'top-sports-female'];

  return Container(
    margin: const EdgeInsets.only(top: 0, bottom: 100),
    width: screenWidth(context),
    height: isDesktop(context)?250:250,
    child: ListView.builder(
        itemCount: topSports.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          return Container(
            margin: const EdgeInsets.only(right: 15),
            child: TextButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(
                        color: Config.secondaryColor,
                      ),
                    )
                );
                UserClass.refreshing = false;
                Sport.setSportInfo(snapshot, topSports, index, customer);
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pushNamed(context, '/mentors-in-sport');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      child: Image.asset('assets/images/$leading${snapshot.data[0]['${topSports[index]}']['sport-name']}.jpg', width: isDesktop(context)?250:180, height: isDesktop(context)?150:130,fit: BoxFit.fill,),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text("${snapshot.data[0]['${topSports[index]}']['sport-name']}",style:  TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop(context)?16:14,
                  ),),
                ],
              ),
            ),
          );
        }),
  );
}


