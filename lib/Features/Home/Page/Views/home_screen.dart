import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';

import '../../../../get_init.dart';

@RoutePage(name: 'Home')
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthRepoImpl authRepo = getIt.get<AuthRepoImpl>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundImage: NetworkImage(authRepo.user!.publicProfileImage),
          ),
        ),
        title: Text(
          "Hello ${authRepo.user!.username.split('@')[0]}",
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.circle_notifications_outlined,
                color: Colors.white,
                size: 35.r,
              ))
        ],
      ),
    );
  }
}
