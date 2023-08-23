import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/get_users_service.dart';
import '../services/socket_service.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  final RefreshController _refreshController = RefreshController();
  final GetUsersService usersService = GetUsersService();

  List<UserModel> users = <UserModel>[];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(authNotifierProvider).user.name),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            ref.read(socketServiceProvider.notifier).disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
          icon: const Icon(Icons.exit_to_app),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: ref.watch(socketServiceProvider) == ServerStatus.Online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green[300],
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
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

  Future<void> loadUsers() async {
    users = await usersService.getUsers();
    setState(() {});
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

class UserListTile extends ConsumerWidget {
  const UserListTile({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      onTap: () {
        final chatService = ref.read(chatServiceNotifierProvider.notifier);
        chatService.userDestiny = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
