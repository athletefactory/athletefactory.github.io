import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../../functions/dimensions.dart';
import '../../functions/platform-type.dart';
import '../../services/database.dart';
import '../../widgets/services-slider.dart';
import '../../widgets/signed-out-widgets/drawer-signed-out.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out-mobile.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    isLoggedIn = false;
    currentUserEmail = '';
    currentSignedOutPage = "Services";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isDesktop(context)?false:true,
        title: isDesktop(context)?topBarSignedOut(context):topBarSignedOutMobile(),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: isMobile(context)?drawerSignedOutWidget(context, scaffoldKey):Container(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              servicesSlider(context),
              const SizedBox(height: 20,),
              IntrinsicHeight(
                child: SizedBox(
                  width: screenWidth(context),
                  child: FutureBuilder(
                    future: Future.wait([sportsData(), categoriesData()]),
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
                              Text(" Top Mentorship Services", style:  TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: isDesktop(context)?26:22,
                              ),),
                              mentorshipServices(snapshot),
                              Text(" Top Sports", style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: isDesktop(context)?26:22,
                              ),),
                              sportsList(snapshot),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mentorshipServices(AsyncSnapshot<dynamic> snapshot){

    List<dynamic> topCategories = snapshot.data[1]['top-categories'];

    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 30),
      width: screenWidth(context),
      height: 50,
      child: ListView.builder(
          itemCount: topCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            return Card(
              elevation: 4,
              surfaceTintColor: Config.textFieldColor,
              color: Colors.grey[100],
              child: IntrinsicWidth(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/sign-in');
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
            );
          }),
    );
  }

  Widget sportsList(AsyncSnapshot<dynamic> snapshot){

    List<dynamic> topSports = snapshot.data[0]['top-sports'];

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
                onPressed: (){
                  Navigator.pushNamed(context, '/sign-in');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                        child: Image.asset('assets/images/${snapshot.data[0]['${topSports[index]}']['sport-name']}.jpg', width: isDesktop(context)?250:180, height: isDesktop(context)?150:130,fit: BoxFit.fill,),
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

}
