// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_model.dart';
import 'package:law_app/features/admin/presentation/ad/pages/ad_management_form_page.dart';
import 'package:law_app/features/admin/presentation/ad/pages/ad_management_home_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_article_form_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_article_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_curriculum_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_detail_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_form_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_home_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_material_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_question_detail_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_question_form_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_question_list_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_quiz_form_page.dart';
import 'package:law_app/features/admin/presentation/course/pages/admin_course_quiz_page.dart';
import 'package:law_app/features/admin/presentation/discussion/pages/admin_discussion_detail_page.dart';
import 'package:law_app/features/admin/presentation/discussion/pages/admin_discussion_home_page.dart';
import 'package:law_app/features/admin/presentation/glossary/pages/glossary_management_page.dart';
import 'package:law_app/features/admin/presentation/home/pages/admin_home_page.dart';
import 'package:law_app/features/admin/presentation/library/pages/book_management_category_page.dart';
import 'package:law_app/features/admin/presentation/library/pages/book_management_detail_page.dart';
import 'package:law_app/features/admin/presentation/library/pages/book_management_form_page.dart';
import 'package:law_app/features/admin/presentation/library/pages/book_management_home_page.dart';
import 'package:law_app/features/admin/presentation/library/pages/book_management_list_page.dart';
import 'package:law_app/features/admin/presentation/master_data/pages/master_data_form_page.dart';
import 'package:law_app/features/admin/presentation/master_data/pages/master_data_home_page.dart';
import 'package:law_app/features/admin/presentation/master_data/pages/master_data_user_detail_page.dart';
import 'package:law_app/features/admin/presentation/reference/pages/discussion_category_page.dart';
import 'package:law_app/features/admin/presentation/reference/pages/reference_page.dart';
import 'package:law_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:law_app/features/auth/presentation/pages/login_page.dart';
import 'package:law_app/features/auth/presentation/pages/otp_page.dart';
import 'package:law_app/features/auth/presentation/pages/register_page.dart';
import 'package:law_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:law_app/features/common/ad_detail_page.dart';
import 'package:law_app/features/common/main_menu_page.dart';
import 'package:law_app/features/common/wrapper.dart';
import 'package:law_app/features/glossary/presentation/pages/glossary_detail_page.dart';
import 'package:law_app/features/glossary/presentation/pages/glossary_search_page.dart';
import 'package:law_app/features/library/presentation/pages/library_book_detail_page.dart';
import 'package:law_app/features/library/presentation/pages/library_book_list_page.dart';
import 'package:law_app/features/library/presentation/pages/library_finished_book_page.dart';
import 'package:law_app/features/library/presentation/pages/library_read_book_page.dart';
import 'package:law_app/features/library/presentation/pages/library_saved_book_page.dart';
import 'package:law_app/features/library/presentation/pages/library_search_page.dart';
import 'package:law_app/features/profile/presentation/pages/account_info_page.dart';
import 'package:law_app/features/profile/presentation/pages/contact_us_page.dart';
import 'package:law_app/features/profile/presentation/pages/faq_page.dart';
import 'package:law_app/features/profile/presentation/pages/profile_page.dart';
import 'package:law_app/features/shared/pages/public_discussion_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_article_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_detail_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_material_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_progress_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_quiz_home_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_quiz_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_rate_page.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_search_page.dart';
import 'package:law_app/features/student/presentation/discussion/pages/student_discussion_detail_page.dart';
import 'package:law_app/features/student/presentation/discussion/pages/student_discussion_list_page.dart';
import 'package:law_app/features/teacher/presentation/discussion/pages/teacher_discussion_detail_page.dart';
import 'package:law_app/features/teacher/presentation/discussion/pages/teacher_discussion_history_page.dart';
import 'package:law_app/features/teacher/presentation/discussion/pages/teacher_discussion_list_page.dart';

// Register the RouteObserver as a navigation observer
final routeObserver = RouteObserver<ModalRoute<void>>();

// App routes generator
Route<dynamic>? generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case wrapperRoute:
      return MaterialPageRoute(
        builder: (_) => const Wrapper(),
      );
    case loginRoute:
      final bannerData = settings.arguments as Map<String, Object>?;

      return MaterialPageRoute(
        builder: (_) => LoginPage(bannerData: bannerData),
      );
    case registerRoute:
      return MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      );
    case forgotPasswordRoute:
      return MaterialPageRoute(
        builder: (_) => const ForgotpasswordPage(),
      );
    case otpRoute:
      final args = settings.arguments as OtpPageArgs;

      return MaterialPageRoute(
        builder: (_) => OtpPage(
          email: args.email,
          otp: args.otp,
        ),
      );
    case resetPasswordRoute:
      final args = settings.arguments as OtpPageArgs;

      return MaterialPageRoute(
        builder: (_) => ResetPasswordPage(
          email: args.email,
          otp: args.otp,
        ),
      );
    case mainMenuRoute:
      return MaterialPageRoute(
        builder: (_) => const MainMenuPage(),
      );
    case profileRoute:
      return MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      );
    case accountInfoRoute:
      return MaterialPageRoute(
        builder: (_) => const AccountInfoPage(),
      );
    case faqRoute:
      return MaterialPageRoute(
        builder: (_) => const FAQPage(),
      );
    case contactUsRoute:
      return MaterialPageRoute(
        builder: (_) => const ContactUsPage(),
      );
    case glossarySearchRoute:
      return PageRouteBuilder(
        pageBuilder: (_, __, ___) => const GlossarySearchPage(),
        transitionDuration: Duration.zero,
      );
    case glossaryDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => GlossaryDetailPage(id: id),
      );
    case libraryBookListRoute:
      return MaterialPageRoute(
        builder: (_) => const LibraryBookListPage(),
      );
    case libraryFinishedBookRoute:
      return MaterialPageRoute(
        builder: (_) => const LibraryFinishedBookPage(),
      );
    case librarySavedBookRoute:
      return MaterialPageRoute(
        builder: (_) => const LibrarySavedBookPage(),
      );
    case librarySearchRoute:
      return MaterialPageRoute(
        builder: (_) => const LibrarySearchPage(),
      );
    case libraryBookDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => LibraryBookDetailPage(id: id),
      );
    case libraryReadBookRoute:
      final args = settings.arguments as LibraryReadBookPageArgs;

      return MaterialPageRoute(
        builder: (_) => LibraryReadBookPage(
          path: args.path,
          book: args.book,
        ),
      );
    case publicDiscussionRoute:
      return MaterialPageRoute(
        builder: (_) => const PublicDiscussionPage(),
      );
    case studentDiscussionListRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentDiscussionListPage(),
      );
    case studentDiscussionDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => StudentDiscussionDetailPage(id: id),
      );
    case teacherDiscussionListRoute:
      return MaterialPageRoute(
        builder: (_) => const TeacherDiscussionListPage(),
      );
    case teacherDiscussionDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => TeacherDiscussionDetailPage(id: id),
      );
    case teacherDiscussionHistoryRoute:
      return MaterialPageRoute(
        builder: (_) => const TeacherDiscussionHistoryPage(),
      );
    case studentCourseSearchRoute:
      return MaterialPageRoute(
        builder: (_) => const StudentCourseSearchPage(),
      );
    case studentCourseDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => StudentCourseDetailPage(id: id),
      );
    case studentCourseProgressRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => StudentCourseProgressPage(id: id),
      );
    case studentCourseMaterialRoute:
      final args = settings.arguments as StudentCourseMaterialPageArgs;

      return MaterialPageRoute(
        builder: (_) => StudentCourseMaterialPage(
          curriculumId: args.curriculumId,
          userCourseId: args.userCourseId,
        ),
      );
    case studentCourseArticleRoute:
      final args = settings.arguments as StudentCourseArticlePageArgs;

      return MaterialPageRoute(
        builder: (_) => StudentCourseArticlePage(
          id: args.id,
          userCourseId: args.userCourseId,
          curriculumSequenceNumber: args.curriculumSequenceNumber,
          materialSequenceNumber: args.materialSequenceNumber,
          totalMaterials: args.totalMaterials,
        ),
      );

    case studentCourseQuizHomeRoute:
      final args = settings.arguments as StudentCourseQuizHomePageArgs;

      return MaterialPageRoute(
        builder: (_) => StudentCourseQuizHomePage(
          id: args.id,
          userCourseId: args.userCourseId,
          curriculumSequenceNumber: args.curriculumSequenceNumber,
          materialSequenceNumber: args.materialSequenceNumber,
          totalMaterials: args.totalMaterials,
        ),
      );
    case studentCourseQuizRoute:
      final quiz = settings.arguments as QuizModel;

      return MaterialPageRoute(
        builder: (_) => StudentCourseQuizPage(quiz: quiz),
      );
    case studentCourseRateRoute:
      final course = settings.arguments as CourseModel;

      return MaterialPageRoute(
        builder: (_) => StudentCourseRatePage(course: course),
      );
    case adminHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      );
    case referenceRoute:
      return MaterialPageRoute(
        builder: (_) => const ReferencePage(),
      );
    case discussionCategoryRoute:
      return MaterialPageRoute(
        builder: (_) => const DiscussionCategoryPage(),
      );
    case adManagementHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdHomePage(),
      );
    case adManagementFormRoute:
      final args = settings.arguments as AdManagementFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => AdManagementFormPage(
          title: args.title,
          ad: args.ad,
        ),
      );
    case adDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => AdDetailPage(id: id),
      );
    case adminCourseHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdminCourseHomePage(),
      );
    case adminCourseFormRoute:
      final args = settings.arguments as AdminCourseFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => AdminCourseFormPage(
          title: args.title,
          course: args.course,
        ),
      );
    case adminCourseDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => AdminCourseDetailPage(id: id),
      );
    case adminCourseCurriculumRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => AdminCourseCurriculumPage(id: id),
      );
    case adminCourseMaterialRoute:
      final curriculumId = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => AdminCourseMaterialPage(curriculumId: curriculumId),
      );
    case adminCourseArticleRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => AdminCourseArticlePage(id: id),
      );
    case adminCourseArticleFormRoute:
      final args = settings.arguments as AdminCourseArticleFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => AdminCourseArticleFormPage(
          title: args.title,
          curriculumId: args.curriculumId,
          article: args.article,
        ),
      );
    case adminCourseQuizRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => AdminCourseQuizPage(id: id),
      );
    case adminCourseQuizFormRoute:
      final args = settings.arguments as AdminCourseQuizFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => AdminCourseQuizFormPage(
          title: args.title,
          curriculumId: args.curriculumId,
          quiz: args.quiz,
        ),
      );
    case adminCourseQuestionListRoute:
      final quizId = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => AdminCourseQuestionListPage(quizId: quizId),
      );
    case adminCourseQuestionDetailRoute:
      final args = settings.arguments as AdminCourseQuestionDetailPageArgs;

      return MaterialPageRoute(
        builder: (_) => AdminCourseQuestionDetailPage(
          id: args.id,
          number: args.number,
        ),
      );
    case adminCourseQuestionFormRoute:
      final args = settings.arguments as AdminCourseQuestionFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => AdminCourseQuestionFormPage(
          id: args.id,
          number: args.number,
        ),
      );
    case adminDiscussionHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const AdminDiscussionHomePage(),
      );
    case adminDiscussionDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => AdminDiscussionDetailPage(id: id),
      );
    case masterDataHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const MasterDataHomePage(),
      );
    case masterDataFormRoute:
      final args = settings.arguments as MasterDataFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => MasterDataFormPage(
          title: args.title,
          role: args.role,
          user: args.user,
        ),
      );
    case masterDataUserDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => MasterDataUserDetailPage(id: id),
      );
    case glossaryManagementRoute:
      return MaterialPageRoute(
        builder: (_) => const GlossaryManagementPage(),
      );
    case bookManagementHomeRoute:
      return MaterialPageRoute(
        builder: (_) => const BookManagementHomePage(),
      );
    case bookManagementCategoryRoute:
      return MaterialPageRoute(
        builder: (_) => const BookManagementCategoryPage(),
      );
    case bookManagementListRoute:
      return MaterialPageRoute(
        builder: (_) => const BookManagementListPage(),
      );
    case bookManagementFormRoute:
      final args = settings.arguments as BookManagementFormPageArgs;

      return MaterialPageRoute(
        builder: (_) => BookManagementFormPage(
          title: args.title,
          book: args.book,
        ),
      );
    case bookManagementDetailRoute:
      final id = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => BookManagementDetailPage(id: id),
      );
    default:
      return null;
  }
}
