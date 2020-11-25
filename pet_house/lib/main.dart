import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_house/Khaled/favorite.dart';
import 'package:pet_house/Khaled/folder.dart';
import 'package:pet_house/Khaled/nestedFolder.dart';
import 'package:pet_house/Khaled/user.dart';
import 'package:pet_house/commons/const.dart';
import 'package:pet_house/authentication.dart';
import 'package:pet_house/localization/l10n/demo_localization.dart';
import 'package:pet_house/localization/l10n/language_constants.dart';
import 'package:pet_house/userprofile2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'commons/utils.dart';
import 'controllers/FBCloudMessaging.dart';
import 'threadMain.dart';
import 'package:pet_house/loginScreen.dart';
import 'package:pet_house/tasks.dart';
import 'package:pet_house/blocks/auth_bloc.dart';



void main() {
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
  }

class MyApp extends StatefulWidget {
  final String initialRoute;
  MyApp({this.initialRoute});

  //const MyApp({Key key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800])),
        ),
      );
    } else {
      return Provider(
        create: (context) => AuthBloc(),
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: LoginScreen(),
          locale: _locale,
          supportedLocales: [
            Locale("en", "US"),
            Locale("fa", "IR"),
            Locale("ar", "YE"),
            Locale("tr", "TR")
          ],
          localizationsDelegates: [
            DemoLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
        ),
      );
    }
  }
}

// another page
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _tabController;
  MyProfileData myData;
  UserData userData;

  bool _isLoading = false;

  @override
  void initState() {
    FBCloudMessaging.instance.takeFCMTokenWhenAppLaunch();
    FBCloudMessaging.instance.initLocalNotification();
    _tabController = new TabController(vsync: this, length: 5);
    _tabController.addListener(_handleTabSelection);
    _takeMyData();
    super.initState();
  }

  Future<void> _takeMyData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myThumbnail;
    String myName;

    if (prefs.get('myName') == null) {
      String tempName = Utils.getRandomString(8);
      prefs.setString('myName', tempName);
      myName = tempName;
    } else {
      myName = prefs.get('myName');
    }

    //myName = "khaled";

    /* myName = emailEmail;

    myName = myName.substring(0, myName.indexOf('@'));
    myName = myName.replaceFirst('@', "");

    prefs.setString('myName', myName);*/

    final Firestore database = Firestore.instance;
    Future<DocumentSnapshot> snapshot =
        database.collection('Profile').document(uid).get();

    // print("msmsmsmsmsmmsmsms $myName");
    setState(() {
      snapshot.then((DocumentSnapshot userSnapshot) async {
        //used to be arrow
        /* insert here the code of what you want to do with the snapshot*/

        //globalProfileName = userSnapshot['name'];
        globalProfileName = "Please";

        userData = UserData(
            name: userSnapshot['name'] ?? 'Khaled',
            age: userSnapshot['age'] ?? '44',
            phoneNumber: userSnapshot['PhoneNumber'] ?? '313',
            profileImage: userSnapshot['profileImage'] ??
                'https://picsum.photos/250?image=9');
      });

      myData = MyProfileData(
        myThumbnail: myThumbnail,
        myName: myName,
        myLikeList: prefs.getStringList('likeList'),
        myLikeCommnetList: prefs.getStringList('likeCommnetList'),
        myFCMToken: prefs.getString('FCMToken'),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _handleTabSelection() => setState(() {});

  void onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void updateMyData(MyProfileData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'title')),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => signOutUser().then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false);
            }),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          TabBarView(controller: _tabController, children: [
            ThreadMain(
              myData: myData,
              updateMyData: updateMyData,
            ),
            Your(
              //uid: null,
              myData: myData,
              updateMyData: updateMyData,
            ),
            Favorite(
              //uid: null,
              myData: myData,
              updateMyData: updateMyData,
            ),
            Folder(
              //uid: null,
              myData: myData,
              updateMyData: updateMyData,
            ),
            UserProfile(
              myData: myData,
              // updateMyDataToMain: updateMyData,
              userData: userData,
            ),
          ]),
          Utils.loadingCircle(_isLoading),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _tabController.index,
        selectedItemColor: Colors.amber[900],
        unselectedItemColor: Colors.grey[800],
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.people),
            title: new Text(getTranslated(context, 'dashBoard')),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.face),
            title: new Text(getTranslated(context, 'poems')),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.star),
            title: new Text(getTranslated(context, 'favorite')),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            title: new Text(getTranslated(context, 'folder')),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            title: new Text(getTranslated(context, 'profile')),
          ),
        ],
      ),
    );
  }
}

String globalProfileName;
