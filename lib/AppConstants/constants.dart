import 'package:assessmentportal/AppConstants/Themes.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

const String domain = "https://assessmentportalwebapp.azurewebsites.net";

const BEARER_TOKEN = "BEARER TOKEN";
const IS_LOGGED_IN = "isLoggedIn";
const Bearer = "Bearer ";
const USERNAME = "username";
const EMAIL = "email";
const ROLE = "USER_ROLE";
const ROLE_NORMAL = 'ROLE_NORMAL';
const USER_ID = "USER_ID";

enum LoadingStatus { NOT_STARTED, LOADING, COMPLETED }

enum AccountType { ADMIN, NORMAL }

enum QuestionLoadingStatus { NOT_STARTED, LOADING, COMPLETED, ERROR }

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingIndicator(
        strokeWidth: 0.5,
        indicatorType: Indicator.ballPulse,
        colors: [
          appBarColor,
        ],
      ),
    );
  }
}

class DataLoadingIndicator extends StatelessWidget {
  const DataLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: const LoadingIndicator(
        indicatorType: Indicator.lineScale,
        colors: [
          Colors.purple,
          // Colors.indigo,
          // Colors.blue,
          // Colors.green,
          // Colors.red,
        ],

        /// Optional, The color collections
        strokeWidth: 0.5,
      ),
    );
  }
}
