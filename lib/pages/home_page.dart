import 'package:chat_application/helper/helper_function.dart';
import 'package:chat_application/pages/login_page.dart';
import 'package:chat_application/pages/profile_page.dart';
import 'package:chat_application/pages/search_page.dart';
import 'package:chat_application/services/auth_services.dart';
import 'package:chat_application/services/database_service.dart';
import 'package:chat_application/widgets/group_tile.dart';
import 'package:chat_application/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String user = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        user = value!;
      });
    });

    //--------------getting list of snapshots---------------//

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshots) {
      setState(() {
        groups = snapshots;
      });
    });
  }

  /* --------------------------- String Manipulation -------------------------- */

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'Groups',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              nextScreen(context, const SearchPage());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              user,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Divider(
              height: 2,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {},
              selected: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              selectedColor: Theme.of(context).primaryColor,
              leading: const Icon(Icons.group),
              title: const Text(
                'Groups',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfilePage(
                      userName: user,
                      userEmail: email,
                    ));
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              leading: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Logout',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text('Are you sure you wish to logout?'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await HelperFunctions.saveUserLoggedInStatus(
                                  false);
                              await HelperFunctions.saveUserEmail("");
                              authService.signout().whenComplete(
                                () {
                                  nextScreenReplace(context, const LoginPage());
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0,
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popupDialog(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  popupDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create a new Group',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter Group Name',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),

                  /* ------------------------------ Create New Group ------------------------------ */

                  onPressed: () async {
                    if (groupName != null) {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(user,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(
                        () {
                          setState(() {
                            _isLoading = false;
                          });
                        },
                      );
                      Navigator.of(context).pop();
                      showSnackbar(context, Colors.green, "Group Created!");
                    } else {
                      showSnackbar(
                          context, Colors.red, "Please enter a Group Name");
                    }
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  noGroupWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              popupDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[400],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Tap the Button below to join or\n create a group',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data["groups"].length,
                itemBuilder: ((context, index) {
                  /* ----------------------- Display Recent Groups First ---------------------- */

                  int reverseIndex = snapshot.data['groups'].length - index - 1;

                  return GroupTile(
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                }),
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
}
