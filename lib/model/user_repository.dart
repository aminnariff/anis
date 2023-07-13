import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserRepository extends StatefulWidget {
  const UserRepository({super.key});

  @override
  State<UserRepository> createState() => _UserRepositoryState();
}

class _UserRepositoryState extends State<UserRepository> {

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}