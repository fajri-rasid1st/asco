// Project imports:
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

const List<Profile> assistantDummies = [
 Profile(
      username: 'rafmas',
      nickname: 'Masloman',
      fullname: 'Rafly Masloman',
      classOf: '2016',
    ),
Profile(
    username: 'cick',
    nickname: 'Fajri',
    fullname: 'Muhammad Fajri Rasid',
    classOf: '2019',
  )

];

const List<Profile> studentDummies = [
  Profile(
    username: 'H071211001',
    nickname: 'Ananda',
    fullname: 'Wd. Ananda Lesmono',
    classOf: '2021',
  ),
  Profile(
    username: 'H071211002',
    nickname: 'Fiantika',
    fullname: 'Febi Fiantika',
    classOf: '2021',
  ),
  Profile(
    username: 'H071211003',
    nickname: 'Hanni',
    fullname: 'Eka Hanni Oktavia',
    classOf: '2021',
  ),
  Profile(
    username: 'H071211004',
    nickname: 'Unnisa',
    fullname: 'Dhiya Unnisa',
    classOf: '2021',
  ),
  Profile(
    username: 'H071211005',
    nickname: 'Dewi',
    fullname: 'Liska Dewi Rombe',
    classOf: '2021',
  ),
];

const List<Meeting> meetingDummies = [
  Meeting(
    number: 1,
    lesson: 'Class and Object',
    date: 1723639819,
    assistant: Profile(
      username: 'cick',
      nickname: 'Fajri',
      fullname: 'Muhammad Fajri Rasid',
      classOf: '2019',
    ),
    coAssistant: Profile(
      username: 'rafmas',
      nickname: 'Masloman',
      fullname: 'Rafly Masloman',
      classOf: '2016',
    ),
  ),
  Meeting(
    number: 2,
    lesson: 'Introduce to Flutter',
    date: 1724590199,
    coAssistant: Profile(
      username: 'cick',
      nickname: 'Fajri',
      fullname: 'Muhammad Fajri Rasid',
      classOf: '2019',
    ),
    assistant: Profile(
      username: 'rafmas',
      nickname: 'Masloman',
      fullname: 'Rafly Masloman',
      classOf: '2016',
    ),
  ),
  Meeting(
    number: 3,
    lesson: 'Inherited Widget',
    date: 1725367799,
    assistant: Profile(
      username: 'cick',
      nickname: 'Fajri',
      fullname: 'Muhammad Fajri Rasid',
      classOf: '2019',
    ),
    coAssistant: Profile(
      username: 'rafmas',
      nickname: 'Masloman',
      fullname: 'Rafly Masloman',
      classOf: '2016',
    ),
  ),
];

const List<Practicum> practicumDummies = [
  Practicum(
    course: 'Pemrograman Mobile A',
    badgePath: 'https://storage.googleapis.com/asco-app-2905.appspot.com/1723630188050.png',
    courseContractPath: 'Setiap hari Sabtu, Pukul 9.30 - 11.30',
  ),
  Practicum(
    course: 'Sistem Basis Data B',
    badgePath: 'https://storage.googleapis.com/asco-app-2905.appspot.com/1723638697645.png',
    courseContractPath: 'Setiap hari Jum\'at, Pukul 13.00 - 15.00',
  ),
];

const List<String> dummyNames = ['Richard', 'Sony', 'Ikhsan'];
const List<String> dummyScores = ['99.0', '95.0', '93.0'];
