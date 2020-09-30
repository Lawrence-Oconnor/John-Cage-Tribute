import 'package:flutter/material.dart';

import 'package:jct/src/blocs/auth/bloc.dart';
import 'package:jct/src/constants/guest_user.dart';
import 'package:jct/src/constants/user_auth.dart';
import 'package:jct/src/models/user_model.dart';
import 'package:jct/src/widgets/loading_user.dart';

class AuthScreen extends StatelessWidget {
  Widget build(context) {
    final AuthBloc bloc = AuthProvider.of(context);

    return StreamBuilder(
      stream: bloc.user,
      builder: (context, AsyncSnapshot<UserModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingUser();
        }

        if (snapshot.data != GUEST_USER) {
          return Scaffold(
            body: logoutView(context, bloc, snapshot.data.username),
          );
        } else {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).accentColor,
                title: Text('Account'),
                centerTitle: true,
                bottom: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: 'Login'),
                    Tab(text: 'Sign Up'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  loginView(context, bloc),
                  signupView(context, bloc),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget logoutView(BuildContext context, AuthBloc bloc, String username) {
    return SizedBox.expand(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Not $username?\n Feel free to log out below.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
            RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: () async {
                await bloc.logout();
              },
              child: Text('Log out', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginView(BuildContext context, AuthBloc bloc) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Container(
            color: Theme.of(context).primaryColor,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Get your persona going.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            emailField(bloc, UserAuth.LOGIN),
            passwordField(bloc, UserAuth.LOGIN),
            loginButton(bloc),
          ],
        ),
      ],
    );
  }

  Widget signupView(BuildContext context, AuthBloc bloc) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Container(
            color: Theme.of(context).primaryColor,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Tired of acting as a guest?\nSign up below.',
              textAlign: TextAlign.center,
            ),
            emailField(bloc, UserAuth.SIGNUP),
            usernameField(bloc),
            passwordField(bloc, UserAuth.SIGNUP),
            confirmPasswordField(bloc),
            signupButton(bloc),
          ],
        ),
      ],
    );
  }

  Widget emailField(AuthBloc bloc, UserAuth authType) {
    return StreamBuilder(
      stream: authType == UserAuth.LOGIN ? bloc.loginEmail : bloc.signupEmail,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onChanged: authType == UserAuth.LOGIN
              ? bloc.changeLoginEmail
              : bloc.changeSignupEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'johndoe@example.com',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget usernameField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.username,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onChanged: bloc.changeUsername,
          decoration: InputDecoration(
            labelText: 'Username',
            hintText: 'Three or more letters or numbers.',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(AuthBloc bloc, UserAuth authType) {
    return StreamBuilder(
      stream:
          authType == UserAuth.LOGIN ? bloc.loginPassword : bloc.signupPassword,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          obscureText: true,
          onChanged: authType == UserAuth.LOGIN
              ? bloc.changeLoginPassword
              : bloc.changeSignupPassword,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Use capitals and numbers.',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget confirmPasswordField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.confirmPassword,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          obscureText: true,
          onChanged: bloc.changeConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Confirm the password above.',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget signupButton(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.signupValid,
      builder: (context, snapshot) {
        return Column(
          children: [
            StreamBuilder(
              stream: bloc.submitSignup,
              builder: (context, AsyncSnapshot<String> snapshot) {
                return Text(
                  snapshot.hasError ? snapshot.error : '',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                );
              },
            ),
            RaisedButton(
              onPressed:
                  snapshot.hasData ? () => onSignup(context, bloc) : null,
              color: Theme.of(context).accentColor,
              child: Text('Sign Up', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget loginButton(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.loginValid,
      builder: (context, snapshot) {
        return Column(
          children: [
            StreamBuilder(
              stream: bloc.submitLogin,
              builder: (context, AsyncSnapshot<String> snapshot) {
                return Text(
                  snapshot.hasError ? snapshot.error : '',
                  style: TextStyle(
                    color: Colors.red[700],
                  ),
                );
              },
            ),
            RaisedButton(
              onPressed: snapshot.hasData ? () => onLogin(context, bloc) : null,
              color: Theme.of(context).accentColor,
              child: Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void onSignup(BuildContext context, AuthBloc bloc) async {
    bool success = await bloc.submitAndSignup();

    if (success) {
      print('Signup successful!');
    } else {
      print('Signup error, bruv.');
    }
  }

  void onLogin(BuildContext context, AuthBloc bloc) async {
    bool success = await bloc.submitAndLogin();

    if (success) {
      print('Login successful!');
    } else {
      print('Login error, bruv.');
    }
  }
}