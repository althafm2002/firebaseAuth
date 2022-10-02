import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseaut/screens/dashboard/controller/dashboeard_provider.dart';
import 'package:firebaseaut/screens/login/controller/authentication_login_provider.dart';
import 'package:firebaseaut/screens/login/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenDashBoard extends StatelessWidget {
  const ScreenDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseAuthLogInProvider>(context, listen: false);
    final dash = Provider.of<DashBoardProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dash.getData();
    });
    return StreamBuilder<User?>(
      stream: data.straem(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ScreenLogin();
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              dash.navigationToAdd(context);
              // await FirebaseFirestore.instance
              //     .collection(
              //         FirebaseAuth.instance.currentUser!.email.toString())
              //     .add({
              //   "name": "shabunew",
              //   "age": "20",
              // });
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    dash.navigationToProfile(context);
                  },
                  icon: const Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 42,
                  )),
              const SizedBox(
                width: 20,
              ),
              TextButton.icon(
                onPressed: () async {
                  await data.signOutPage(context);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                label: const Text(
                  'SignOut',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<DashBoardProvider>(
                builder: (BuildContext context, DashBoardProvider value,
                    Widget? child) {
                  return value.userModel == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(value.userModel?.name ?? "no name"),
                            Text(
                              (value.userModel?.email ?? ""),
                            ),
                          ],
                        );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
