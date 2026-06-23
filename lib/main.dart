import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/data/mock/event_store.dart';
import 'package:evora/data/mock/organizer_store.dart';
import 'package:evora/data/mock/waitlist_store.dart';
import 'package:evora/router.dart';
import 'package:evora/theme/app_theme.dart';

void main() => runApp(const EvoraApp());

class EvoraApp extends StatelessWidget {
  const EvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventStore()),
        ChangeNotifierProvider(create: (_) => OrganizerStore()),
        ChangeNotifierProvider(create: (_) => BookingStore()),
        ChangeNotifierProvider(create: (_) => WaitlistStore()),
      ],
      child: MaterialApp.router(
        title: 'Evora',
        debugShowCheckedModeBanner: false,
        theme: lightTheme(),
        darkTheme: darkTheme(),
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
