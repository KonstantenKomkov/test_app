// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:test_app/classes.dart';
import 'package:test_app/prefs.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User>? users;
  Object? error;
  bool isLoading = false;
  final sharedPrefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  Future<void> initSharedPrefs() async {
    setState(() {
      isLoading = true;
    });
    await sharedPrefs.init();
    final _data = await sharedPrefs.getUsers();
    setState(() {
      users = _data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Users'),
        ),
        body: Container(
          child: _usersListView(context, users),
        ),
      ),
    );
  }

  Widget _usersListView(BuildContext context, List<User>? users) {
    if (users != null) {
      return ListView.separated(
        itemCount: users.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) =>
            _buildUsersCard(context, users[index]),
      );
    } else if (error != null) {
      return Text(
        'Error: ${error.toString()}',
        style: Theme.of(context).textTheme.headline4,
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _buildUsersCard(BuildContext context, User user) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/user',
          arguments: user,
        );
      },
      child: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 36.0,
                  bottom: 36.0,
                  top: 18.0,
                ),
                child: Text(
                  user.userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 52,
              top: 52,
              child: Text(user.name),
            ),
          ],
        ),
      ),
    );
  }
}
