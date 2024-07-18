// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/pages/assistance_group_detail_page.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/pages/assistance_group_form_page.dart';
import 'package:asco/src/presentation/features/admin/assistance_group/pages/assistance_group_list_home_page.dart';
import 'package:asco/src/presentation/features/admin/attendance/pages/attendance_detail_page.dart';
import 'package:asco/src/presentation/features/admin/attendance/pages/attendance_list_home_page.dart';
import 'package:asco/src/presentation/features/admin/classroom/pages/classroom_detail_page.dart';
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
import 'package:asco/src/presentation/features/admin/user/pages/user_detail_page.dart';
import 'package:asco/src/presentation/features/admin/user/pages/user_form_page.dart';
import 'package:asco/src/presentation/features/admin/user/pages/user_list_home_page.dart';
import 'package:asco/src/presentation/features/assistant/assistance/pages/assistant_assistance_detail_page.dart';
import 'package:asco/src/presentation/features/assistant/assistance/pages/assistant_assistance_score_page.dart';
import 'package:asco/src/presentation/features/assistant/extra/pages/edit_extra_page.dart';
import 'package:asco/src/presentation/features/assistant/meeting/pages/assistant_meeting_detail_page.dart';
import 'package:asco/src/presentation/features/assistant/meeting/pages/assistant_meeting_scanner_page.dart';
import 'package:asco/src/presentation/features/assistant/meeting/pages/assistant_meeting_schedule_page.dart';
import 'package:asco/src/presentation/features/assistant/profile/pages/assistant_profile_page.dart';
import 'package:asco/src/presentation/features/common/home/pages/home_page.dart';
import 'package:asco/src/presentation/features/common/initial/pages/on_boarding_page.dart';
import 'package:asco/src/presentation/features/common/main_menu/pages/main_menu_page.dart';
import 'package:asco/src/presentation/features/student/assistance/pages/student_assistance_detail_page.dart';
import 'package:asco/src/presentation/features/student/meeting/pages/student_meeting_detail_page.dart';
import 'package:asco/src/presentation/features/student/meeting/pages/student_meeting_history_page.dart';
import 'package:asco/src/presentation/features/student/profile/pages/student_profile_page.dart';
import 'package:asco/src/presentation/shared/features/control_card/pages/control_card_detail_page.dart';
import 'package:asco/src/presentation/shared/features/extra/pages/lab_exam_info_page.dart';
import 'package:asco/src/presentation/shared/features/profile/pages/edit_profile_page.dart';
import 'package:asco/src/presentation/shared/features/score/pages/score_input_page.dart';
import 'package:asco/src/presentation/shared/features/score/pages/score_recap_detail_page.dart';
import 'package:asco/src/presentation/shared/features/score/pages/score_recap_list_home_page.dart';
import 'package:asco/src/presentation/shared/pages/practitioner_list_page.dart';
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
    case adminHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      );
    case homeRoute:
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
      );
    case mainMenuRoute:
      return MaterialPageRoute(
        builder: (_) => const MainMenuPage(),
      );
    case userListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const UserListHomePage(),
      );
    case userDetailRoute:
      final user = settings.arguments as Profile;

      return MaterialPageRoute(
        builder: (_) => UserDetailPage(user: user),
      );
    case userFormRoute:
      final user = settings.arguments as Profile?;

      return MaterialPageRoute(
        builder: (_) => UserFormPage(user: user),
      );
    case practicumListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const PracticumListHomePage(),
      );
    case practicumDetailRoute:
      final id = settings.arguments as String;

      return MaterialPageRoute(
        builder: (_) => PracticumDetailPage(id: id),
      );
    case practicumFirstFormRoute:
      final args = settings.arguments as PracticumFormPageArgs?;

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
      final args = settings.arguments as ClassroomDetailPageArgs;

      return MaterialPageRoute(
        builder: (_) => ClassroomDetailPage(args: args),
      );
    case meetingListHomeRoute:
      final practicum = settings.arguments as Practicum;

      return MaterialPageRoute(
        builder: (_) => MeetingListHomePage(practicum: practicum),
      );
    case meetingDetailRoute:
      final args = settings.arguments as MeetingDetailPageArgs;

      return MaterialPageRoute(
        builder: (_) => MeetingDetailPage(args: args),
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
    case assistanceGroupListHomeRoute:
      final practicum = settings.arguments as Practicum;

      return MaterialPageRoute(
        builder: (_) => AssistanceGroupListHomePage(practicum: practicum),
      );
    case assistanceGroupDetailRoute:
      final args = settings.arguments as AssistanceGroupDetailPageArgs;

      return MaterialPageRoute(
        builder: (_) => AssistanceGroupDetailPage(args: args),
      );
    case assistanceGroupFormRoute:
      final args = settings.arguments as AssistanceGroupFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => AssistanceGroupFormPage(args: args),
      );
    case controlCardListHomeRoute:
      final practicum = settings.arguments as Practicum;

      return MaterialPageRoute(
        builder: (_) => ControlCardListHomePage(practicum: practicum),
      );
    case labRulesRoute:
      return MaterialPageRoute(
        builder: (_) => const LabRulesPage(),
      );
    case studentMeetingHistoryRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentMeetingHistoryPage(),
      );
    case studentMeetingDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentMeetingDetailPage(),
      );
    case assistantMeetingScheduleRoute:
      return MaterialPageRoute(
        builder: (_) => const AssistantMeetingSchedulePage(),
      );
    case assistantMeetingDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const AssistantMeetingDetailPage(),
      );
    case assistantMeetingScannerRoute:
      return MaterialPageRoute(
        builder: (_) => const AssistantMeetingScannerPage(),
      );
    case studentAssistanceDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentAssistanceDetailPage(),
      );
    case assistantAssistanceDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const AssistantAssistanceDetailPage(),
      );
    case assistantAssistanceScoreRoute:
      return MaterialPageRoute(
        builder: (_) => const AssistantAssistanceScorePage(),
      );
    case controlCardDetailRoute:
      return MaterialPageRoute(
        builder: (_) => const ControlCardDetailPage(),
      );
    case scoreRecapListHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const ScoreRecapListHomePage(),
      );
    case scoreRecapDetailRoute:
      final title = settings.arguments as String;

      return MaterialPageRoute(
        builder: (_) => ScoreRecapDetailPage(title: title),
      );
    case scoreInputRoute:
      final args = settings.arguments as ScoreInputPageArgs;

      return MaterialPageRoute(
        builder: (_) => ScoreInputPage(args: args),
      );
    case labExamInfoRoute:
      return MaterialPageRoute(
        builder: (_) => const LabExamInfoPage(),
      );
    case editExtraRoute:
      final args = settings.arguments as EditExtraPageArgs;

      return MaterialPageRoute(
        builder: (_) => EditExtraPage(args: args),
      );
    case studentProfileRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentProfilePage(),
      );
    case assistantProfileRoute:
      return MaterialPageRoute(
        builder: (_) => const AssistantProfilePage(),
      );
    case editProfileRoute:
      return MaterialPageRoute(
        builder: (_) => const EditProfilePage(),
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
    case practitionerListRoute:
      final title = settings.arguments as String;

      return MaterialPageRoute(
        builder: (_) => PractitionerListPage(title: title),
      );
    default:
      return null;
  }
}
