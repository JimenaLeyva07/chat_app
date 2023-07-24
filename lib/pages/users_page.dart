import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final RefreshController _refreshController = RefreshController();

  final List<UserModel> users = <UserModel>[
    const UserModel(
      name: 'Jimena',
      email: 'jimena@test.com',
      online: true,
      uid: '1',
    ),
    const UserModel(
      uid: '2',
      name: 'Isabela',
      email: 'isabela@test.com',
    ),
    const UserModel(
      uid: '3',
      name: 'Matías',
      email: 'matias@test.com',
      online: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return Text(ref.watch(authNotifierProvider).user.name);
          },
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            // TODO(Jimena): disconnect from socket server
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
          icon: const Icon(Icons.exit_to_app),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.check_circle,
              color: Colors.green[300],
            ),
            //     const Icon(
            //   Icons.offline_bolt,
            //   color: Colors.red,
            // ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () => loadUsers(),
        header: ClassicHeader(
          completeIcon: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
        ),
        child: UsersListView(users: users),
      ),
    );
  }

  loadUsers() async {
    // monitor network fetch
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}

class UsersListView extends StatelessWidget {
  const UsersListView({
    required this.users,
    super.key,
  });

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) =>
          UserListTile(user: users[index]),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class UserListTile extends StatelessWidget {
  const UserListTile({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
      ),
      title: Text(user.name),
      subtitle: Text(
        user.email,
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
