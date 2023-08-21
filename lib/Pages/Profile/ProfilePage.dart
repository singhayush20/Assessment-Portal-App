import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/Pages/Profile/EditUserDetails.dart';
import 'package:assessmentportal/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditUserDetails(),
            ),
          );
        },
        child: Icon(
          FontAwesomeIcons.pen,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, screenSize) {
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: screenSize.maxWidth * 0.02),
            child: (userProvider.loadingStatus == LoadingStatus.LOADING ||
                    userProvider.loadingStatus == LoadingStatus.NOT_STARTED)
                ? Center(
                    child: Container(
                        height: 100, width: 100, child: DataLoadingIndicator()),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: screenSize.maxHeight * 0.05,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: screenSize.maxHeight * 0.2,
                        child: FittedBox(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: ClipOval(
                              child:
                                  Image.asset('images/DefaultProfileImage.jpg'),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        height: screenSize.maxHeight * 0.05,
                        child: FittedBox(
                          child: Text(
                            userProvider.user!.userName,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: screenSize.maxHeight * 0.55,
                        child: Column(
                          children: [
                            //==NAME==
                            ProfileItem(
                                fieldName: "Name: ",
                                fieldValue: userProvider.user!.firstName +
                                    " " +
                                    userProvider.user!.lastName),
                            //==EMAIL==
                            ProfileItem(
                                fieldName: "Email: ",
                                fieldValue: userProvider.user!.email),
                            //==PHONE==
                            ProfileItem(
                                fieldName: "Phone: ",
                                fieldValue: userProvider.user!.phoneNumber),
                            //==Account Type==
                            ProfileItem(
                                fieldName: "Account Type: ",
                                fieldValue: userProvider.user!.roles[0]
                                    ['roleName']),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  String fieldName;
  String fieldValue;
  TextStyle fieldTextStyle = TextStyle(
    fontSize: 20,
  );
  ProfileItem({required this.fieldName, required this.fieldValue});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black, width: 0.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Color(0xFFF9F9F9),
        ),
        padding: EdgeInsets.only(
          right: 10,
        ),
        margin: EdgeInsets.only(
          bottom: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  fieldName,
                  style: fieldTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  fieldValue,
                  style: fieldTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
