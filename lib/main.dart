import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/load_data.dart';
import 'package:test_app/classes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          return NotFound();
        });
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case UsersPage.routeName:
            return MaterialPageRoute(builder: (BuildContext context) {
              return UsersPage();
            });
          case UserPage.routeName:
            final user = settings.arguments as User;
            print(user);
            return MaterialPageRoute(builder: (BuildContext context) {
              return UserPage(user: user);
            });
          default:
            return MaterialPageRoute(builder: (BuildContext context) {
              return NotFound();
            });
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      //home: UsersPage(title: 'Users'),
    );
  }
}

class UsersPage extends StatefulWidget {
  UsersPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User>? users;
  Object? error;

  void loadData() async {
    try {
      var usersLoad = await loadUsers();
      setState(() {
        users = usersLoad.cast<User>();
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
    loadData();
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

class UserPage extends StatefulWidget {
  static const routeName = '/user';
  UserPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${widget.user.userName}'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.user.name}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${widget.user.email.toLowerCase()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Phone: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '${widget.user.phone}'),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Website: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '${widget.user.website}'),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Company:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Name: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '${widget.user.company.name}'),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Bs: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '${widget.user.company.bs}'),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Catch phrase: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: '— "${widget.user.company.catchPhrase}" —',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            )),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Address:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                      '${widget.user.address.city}, ${widget.user.address.street}, ${widget.user.address.suite}, ${widget.user.address.zipcode}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotFound extends StatefulWidget {
  NotFound({Key? key}) : super(key: key);

  @override
  _NotFoundState createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Not fount'),
        ),
        body: Center(
          child: Container(
            child: Text('Page not found'),
          ),
        ),
      ),
    );
  }
}
