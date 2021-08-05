import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/load_data.dart';
import 'package:test_app/classes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User>? users;
  Object? error;
  bool isLoading = false;
  final sharedPrefs = SharedPrefs();

  void loadData() async {
    try {
      var usersLoad = await loadUsers();
      setState(() {
        users = usersLoad;
      });
    } catch (exception) {
      setState(() {
        error = exception;
        print("Oops, we catch warning: $error");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
    loadData();
  }

  Future<void> initSharedPrefs() async {
    await SharedPrefs.init(); //???
    setState(() {
      isLoading = true;
    });
    final _data = await sharedPrefs.getUsers(); //TODO:
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
          title: Text('Users'),
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
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) =>
            _buildUsersCard(context, users[index]),
      );
    } else if (error != null) {
      return Text(
        'Error: ${error.toString()}',
        style: Theme.of(context).textTheme.headline4,
      );
    } else {
      return CircularProgressIndicator();
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
                padding: EdgeInsets.only(
                  left: 36.0,
                  bottom: 36.0,
                  top: 18.0,
                ),
                child: Text(
                  '${user.userName}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 52,
              top: 52,
              child: Text('${user.name}'),
            ),
          ],
        ),
      ),
    );
  }
}
