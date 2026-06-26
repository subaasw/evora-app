import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:evora/features/admin/organizers_screen.dart';
import 'package:evora/features/admin/register_organizer_screen.dart';
import 'package:evora/features/admin/reports_screen.dart';
import 'package:evora/features/attendee/cart_screen.dart';
import 'package:evora/features/attendee/confirmation_screen.dart';
import 'package:evora/features/attendee/event_detail_screen.dart';
import 'package:evora/features/attendee/event_list_screen.dart';
import 'package:evora/features/attendee/my_tickets_screen.dart';
import 'package:evora/features/attendee/notifications_screen.dart';
import 'package:evora/features/attendee/payment_screen.dart';
import 'package:evora/features/attendee/profile_pages.dart';
import 'package:evora/features/attendee/profile_screen.dart';
import 'package:evora/features/attendee/seat_map_screen.dart';
import 'package:evora/features/attendee/ticket_detail_screen.dart';
import 'package:evora/features/attendee/waitlist_screen.dart';
import 'package:evora/features/auth/forgot_password_screen.dart';
import 'package:evora/features/auth/login_screen.dart';
import 'package:evora/features/auth/signup_screen.dart';
import 'package:evora/features/auth/splash_screen.dart';
import 'package:evora/features/auth/staff_login_screen.dart';
import 'package:evora/features/organizer/analytics_screen.dart';
import 'package:evora/features/organizer/check_in_screen.dart';
import 'package:evora/features/organizer/create_event_screen.dart';
import 'package:evora/features/organizer/my_events_screen.dart';
import 'package:evora/widgets/role_shell.dart';

final _attendeeNav = [
  const RoleNavItem(icon: Icons.explore_outlined, label: 'Browse'),
  const RoleNavItem(icon: Icons.confirmation_number_outlined, label: 'Tickets'),
  const RoleNavItem(icon: Icons.person_outline, label: 'Profile'),
];

final _organizerNav = [
  const RoleNavItem(icon: Icons.event_note_outlined, label: 'Events'),
  const RoleNavItem(icon: Icons.add_circle_outline, label: 'Create'),
  const RoleNavItem(icon: Icons.qr_code_scanner, label: 'Check-in'),
  const RoleNavItem(icon: Icons.bar_chart_outlined, label: 'Analytics'),
];

final _adminNav = [
  const RoleNavItem(icon: Icons.group_outlined, label: 'Organizers'),
  const RoleNavItem(icon: Icons.insert_chart_outlined, label: 'Reports'),
];

/// Pushed full-screen route with a smooth fade + slight slide transition.
GoRoute _route(String path, Widget Function(GoRouterState state) build) => GoRoute(
      path: path,
      pageBuilder: (_, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        child: build(state),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.04), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
      ),
    );

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(path: '/staff-login', builder: (_, _) => const StaffLoginScreen()),
    GoRoute(path: '/signup', builder: (_, _) => const SignUpScreen()),
    GoRoute(path: '/forgot', builder: (_, _) => const ForgotPasswordScreen()),
    _route('/notifications', (_) => const NotificationsScreen()),
    _route('/edit-profile', (_) => const EditProfileScreen()),
    _route('/settings', (_) => const SettingsScreen()),
    _route('/help', (_) => const HelpSupportScreen()),
    _route('/about', (_) => const AboutEvoraScreen()),
    _route('/event/:id', (s) => EventDetailScreen(eventId: s.pathParameters['id']!)),
    _route('/event/:id/seats', (s) => SeatMapScreen(eventId: s.pathParameters['id']!)),
    _route('/event/:id/cart', (s) => CartScreen(eventId: s.pathParameters['id']!)),
    _route('/event/:id/payment', (s) => PaymentScreen(eventId: s.pathParameters['id']!)),
    _route('/event/:id/confirm',
        (s) => ConfirmationScreen(bookingId: s.uri.queryParameters['b'] ?? '')),
    _route('/ticket/:id', (s) => TicketDetailScreen(bookingId: s.pathParameters['id']!)),
    _route('/event/:id/waitlist',
        (s) => WaitlistScreen(eventId: s.pathParameters['id']!)),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => RoleShell(shell: shell, items: _attendeeNav),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/attendee/browse', builder: (_, _) => const EventListScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/attendee/tickets',
            builder: (_, _) => const MyTicketsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/attendee/profile', builder: (_, _) => const ProfileScreen()),
        ]),
      ],
    ),
    _route('/admin/register', (_) => const RegisterOrganizerScreen()),
    _route('/organizer/event/:id/edit',
        (s) => CreateEventScreen(eventId: s.pathParameters['id']!)),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => RoleShell(shell: shell, items: _organizerNav),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/organizer/events', builder: (_, _) => const MyEventsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/organizer/create', builder: (_, _) => const CreateEventScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/organizer/checkin', builder: (_, _) => const CheckInScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/organizer/analytics', builder: (_, _) => const AnalyticsScreen()),
        ]),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => RoleShell(shell: shell, items: _adminNav),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/admin/organizers', builder: (_, _) => const OrganizersScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/admin/reports', builder: (_, _) => const ReportsScreen()),
        ]),
      ],
    ),
  ],
);
