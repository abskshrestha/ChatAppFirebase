import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../pages/search_page.dart';

import '../auth/login_page.dart';
import '../pages/profile_page.dart';
import '../service/auth_service.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = "";
  String userName = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  AuthService authService = AuthService();

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });

//getting the list of snapshots in the stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Groups',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, const SearchPage());
            },
            icon: const Icon(Icons.search),
          ),
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.black,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Divider(
              height: 2,
              thickness: 1,
            ),
            ListTile(
              onTap: () {},
              selectedTileColor: Theme.of(context).primaryColor,
              selected: true,
              title: const Text(
                'Groups',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              leading: const Icon(
                Icons.group,
                color: Colors.black,
              ),
              iconColor: Theme.of(context).primaryColor,
            ),
            ListTile(
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              onTap: () {
                nextScreenReplace(
                    context, ProfilePage(email: email, userName: userName));
              },
            ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onTap: () async {
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you want to logout?'),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel),
                            color: Colors.red,
                          ),
                          IconButton(
                              onPressed: () async {
                                await authService.signOut();

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                              icon: const Icon(Icons.done_rounded),
                              color: Colors.green),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            popUpDialog(context);
          },
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create a group'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (groupName != "") {
                    setState(() {
                      _isLoading = true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();

                    showSnackBar(
                        context, Colors.green, "Group created successfully");
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text('Create'),
              ),
            ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          // make some checks
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        groupName:
                            getName(snapshot.data['groups'][reverseIndex]),
                        userName: snapshot.data['fullName']);
                  },
                );
              } else
                return noGroupWidget();
            } else
              return noGroupWidget();
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          }
        });
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: const Icon(
              Icons.add_circle,
              size: 75,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'You have not joined any group',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Tap on the Add icon to create a group or search on the top to join an existing group',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
