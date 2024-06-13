import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection.dart';
import '../application/auth/auth_bloc.dart';
import '../presentation/routes/router.gr.dart' as app_router;

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final RootStackRouter _appRouter = app_router.Router();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()
            ..add(
              const AuthEvent.authCheckRequested(),
            ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          // primaryColor: Colors.green[800],
          popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  side: BorderSide(color: Colors.blue))),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.green[800], secondary: Colors.blueAccent),
          appBarTheme: ThemeData.light().appBarTheme.copyWith(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.black38,
                  statusBarIconBrightness: Brightness.light,
                ),
                color: Colors.green[800],
                titleTextStyle:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                iconTheme: ThemeData.dark().iconTheme,
              ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            headline4: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              height: 1.3,
            ),
            headline6: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
              height: 1.3,
            ),
            subtitle1: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 15.0,
              height: 1.3,
            ),
            caption: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          progressIndicatorTheme:
              ProgressIndicatorThemeData(color: Colors.blueAccent[800]),
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.green),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
              primary: Colors.blue[800],
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
      ),
    );
  }
}
