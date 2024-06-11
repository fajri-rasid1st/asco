// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/pages/assistance_group_detail_page.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/pages/assistance_group_form_page.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/pages/assistance_group_list_home_page.dart';
import 'package:asco/src/presentation/features/admin/attendance/pages/attendance_detail_page.dart';
import 'package:asco/src/presentation/features/admin/attendance/pages/attendance_list_home_page.dart';
import 'package:asco/src/presentation/features/admin/classroom/pages/classroom_detail_page.dart';
import 'package:asco/src/presentation/features/admin/control_card/pages/control_card_detail_page.dart';
import 'package:asco/src/presentation/features/admin/control_card/pages/control_card_list_home_page.dart';
import 'package:asco/src/presentation/features/admin/home/pages/admin_home_page.dart';
import 'package:asco/src/presentation/features/admin/lab_rules/pages/lab_rules_page.dart';
import 'package:asco/src/presentation/features/admin/meeting/pages/meeting_detail_page.dart';
import 'package:asco/src/presentation/features/admin/meeting/pages/meeting_form_page.dart';
import 'package:asco/src/presentation/features/admin/meeting/pages/meeting_list_home_page.dart';
import 'package:asco/src/presentation/features/admin/practicum/pages/practicum_badge_generator_page.dart';
import 'package:asco/src/presentation/features/admin/practicum/pages/practicum_detail_page.dart';
import 'package:asco/src/presentation/features/admin/practicum/pages/practicum_form_page.dart';
import 'package:asco/src/presentation/features/admin/practicum/pages/practicum_list_home_page.dart';
import 'package:asco/src/presentation/features/admin/score_recap/pages/score_recap_detail_page.dart';
import 'package:asco/src/presentation/features/admin/score_recap/pages/score_recap_list_home_page.dart';
import 'package:asco/src/presentation/features/admin/user/pages/user_detail_page.dart';
import 'package:asco/src/presentation/features/admin/user/pages/user_form_page.dart';
import 'package:asco/src/presentation/features/admin/user/pages/user_list_home_page.dart';
import 'package:asco/src/presentation/features/common/on_boarding_page.dart';
import 'package:asco/src/presentation/features/home/home_page.dart';
import 'package:asco/src/presentation/features/menu/main_menu_page.dart';
import 'package:asco/src/presentation/shared/pages/select_classroom_page.dart';
import 'package:asco/src/presentation/shared/pages/select_practicum_page.dart';
import 'package:asco/src/presentation/shared/pages/select_users_page.dart';

// Register the RouteObserver as a navigation observer
final routeObserver = RouteObserver<ModalRoute<void>>();

// App routes generator
Route<dynamic>? generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case onBoardingRoute:
      return MaterialPageRoute(
        builder: (_) => const OnBoardingPage(),
      );
    case homeRoute:
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
      );
    case mainMenuRoute:
      return MaterialPageRoute(
        builder: (_) => const MainMenuPage(),
      );
    case adminHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      );
    case userListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const UserListHomePage(),
      );
    case userDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const UserDetailPage(),
      );
    case userFormRoute:
      final args = settings.arguments as UserFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => UserFormPage(args: args),
      );
    case practicumListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const PracticumListHomePage(),
      );
    case practicumDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const PracticumDetailPage(),
      );
    case practicumFirstFormRoute:
      final args = settings.arguments as PracticumFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => PracticumFirstFormPage(args: args),
      );
    case practicumSecondFormRoute:
      final args = settings.arguments as PracticumFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => PracticumSecondFormPage(args: args),
      );
    case practicumBadgeGeneratorRoute:
      return MaterialPageRoute(
        builder: (_) => const PracticumBadgeGeneratorPage(),
      );
    case classroomDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const ClassroomDetailPage(),
      );
    case meetingListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const MeetingListHomePage(),
      );
    case meetingDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const MeetingDetailPage(),
      );
    case meetingFormRoute:
      final args = settings.arguments as MeetingFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => MeetingFormPage(args: args),
      );
    case attendanceListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AttendanceListHomePage(),
      );
    case attendanceDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const AttendanceDetailPage(),
      );
    case scoreRecapListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const ScoreRecapListHomePage(),
      );
    case scoreRecapDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const ScoreRecapDetailPage(),
      );
    case assistanceGroupListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AssistanceGroupListHomePage(),
      );
    case assistanceGroupDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const AssistanceGroupDetailPage(),
      );
    case assistanceGroupFormRoute:
      final args = settings.arguments as AssistanceGroupFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => AssistanceGroupFormPage(args: args),
      );
    case controlCardListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const ControlCardListHomePage(),
      );
    case controlCardDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const ControlCardDetailPage(),
      );
    case labRulesRoute:
      return MaterialPageRoute(
        builder: (_) => const LabRulesPage(),
      );
    case selectUsersRoute:
      final args = settings.arguments as SelectUsersPageArgs;

      return MaterialPageRoute(
        builder: (_) => SelectUsersPage(args: args),
      );
    case selectPracticumRoute:
      final args = settings.arguments as SelectPracticumPageArgs;

      return MaterialPageRoute(
        builder: (_) => SelectPracticumPage(args: args),
      );
    case selectClassroomRoute:
      final args = settings.arguments as SelectClassroomPageArgs;

      return MaterialPageRoute(
        builder: (_) => SelectClassroomPage(args: args),
      );
    default:
      return null;
  }
}
