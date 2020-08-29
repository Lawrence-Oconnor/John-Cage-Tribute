import 'package:flutter/material.dart';
import '../blocs/room/bloc.dart';
import '../constants/role.dart';

class RoleButtons extends StatelessWidget {
  Widget build(BuildContext context) {
    final RoomBloc bloc = RoomProvider.of(context);

    return StreamBuilder(
      stream: bloc.role,
      builder: (context, AsyncSnapshot<Role> snapshot) {
        return ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            RaisedButton(
              color: snapshot.hasData && snapshot.data == Role.PERFORMER
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              highlightColor: Colors.white,
              child: Text('Performer',
                  style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                bloc.currentRole = Role.PERFORMER;
                bloc.changeRole(Role.PERFORMER);
              },
            ),
            RaisedButton(
              color: snapshot.hasData && snapshot.data == Role.LISTENER
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              highlightColor: Colors.white,
              child: Text('Listener',
                  style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                bloc.currentRole = Role.LISTENER;
                bloc.changeRole(Role.LISTENER);
              },
            ),
          ],
        );
      },
    );
  }
}