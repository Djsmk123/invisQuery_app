import 'package:flutter/material.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';

import '../../../../get_init.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getIt.get<AuthRepoImpl>().user!.email),
      ),
    );
  }
}
