// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:asco/core/helpers/asset_path.dart';
// class AttendanceDialog extends StatefulWidget {
//   final ProfileEntity student;
//   final AttendanceEntity attendance;
//   final List<AttendanceEntity> listAttendances;

//   const AttendanceDialog({
//     super.key,
//     required this.student,
//     required this.attendance,
//     required this.listAttendances,
//   });

//   @override
//   State<AttendanceDialog> createState() => _AttendanceDialogState();
// }

// class _AttendanceDialogState extends State<AttendanceDialog> {
//   final _listStatus = <FaceStatus>[
//     const FaceStatus(
//       status: 'Alfa',
//       icon: 'face_dizzy_filled.svg',
//       color: Color(0xFFFA78A6),
//     ),
//     const FaceStatus(
//       status: 'Izin',
//       icon: 'face_neutral_filled.svg',
//       color: Color(0xFF788DFA),
//     ),
//     const FaceStatus(
//       status: 'Sakit',
//       icon: 'face_sick_filled.svg',
//       color: Color(0xFFFAC678),
//     ),
//     const FaceStatus(
//       status: 'Hadir',
//       icon: 'face_smile_filled.svg',
//       color: Palette.purple60,
//     ),
//   ];

//   final _listPoints = <int>[5, 10, 15, 20, 25, 30];

//   late final ValueNotifier<FaceStatus> _statusNotifier;
//   late final ValueNotifier<int> _pointNotifier;
//   late final TextEditingController _noteController;

//   @override
//   void initState() {
//     _statusNotifier = ValueNotifier(
//       widget.attendance.attendanceStatus == null
//           ? _listStatus.first
//           : _listStatus[widget.attendance.attendanceStatus!],
//     );

//     _pointNotifier = ValueNotifier(
//       widget.attendance.pointPlus == null
//           ? _listPoints.first
//           : _listPoints.firstWhere((e) => e == widget.attendance.pointPlus!),
//     );

//     _noteController = TextEditingController();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _statusNotifier.dispose();
//     _pointNotifier.dispose();
//     _noteController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       elevation: 0,
//       insetPadding: const EdgeInsets.symmetric(
//         horizontal: 36.0,
//         vertical: 24.0,
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.only(
//           top: 8,
//           bottom: 24,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: Row(
//                 children: <Widget>[
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(
//                       Icons.close_rounded,
//                       color: Palette.purple100,
//                     ),
//                     tooltip: 'Close',
//                   ),
//                   Expanded(
//                     child: Text(
//                       'Absensi',
//                       textAlign: TextAlign.center,
//                       style: kTextTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.w700,
//                         color: Palette.purple100,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       final index = _listStatus.indexWhere((e) {
//                         return e.status == _statusNotifier.value.status;
//                       });

//                       final point = _pointNotifier.value;

//                       final result = UpdateDataHelper.updateAttendance(
//                         studentUid: widget.student.uid ?? '',
//                         attendanceList: widget.listAttendances,
//                         updateAttendance: AttendanceEntity(
//                           attendanceStatus: index,
//                           attendanceTime: DateTime.now(),
//                           note: index == 3 ? null : _noteController.text,
//                           pointPlus: index == 3 ? point : null,
//                           quizScore: null,
//                         ),
//                       );

//                       Navigator.pop(context, result);
//                     },
//                     icon: const Icon(
//                       Icons.check_rounded,
//                       color: Palette.purple60,
//                     ),
//                     tooltip: 'Submit',
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     widget.student.username!,
//                     style: kTextTheme.bodyLarge?.copyWith(
//                       color: Palette.purple60,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     widget.student.fullName!,
//                     style: kTextTheme.titleSmall?.copyWith(
//                       fontWeight: FontWeight.w700,
//                       color: Palette.purple80,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   AttendanceOptions(
//                     statusNotifier: _statusNotifier,
//                     pointNotifier: _pointNotifier,
//                     noteController: _noteController,
//                     listStatus: _listStatus,
//                     listPoints: _listPoints,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AttendanceOptions extends StatelessWidget {
//   final ValueNotifier<FaceStatus> statusNotifier;
//   final ValueNotifier<int> pointNotifier;
//   final TextEditingController noteController;
//   final List<FaceStatus> listStatus;
//   final List<int> listPoints;

//   const AttendanceOptions({
//     super.key,
//     required this.statusNotifier,
//     required this.pointNotifier,
//     required this.noteController,
//     required this.listStatus,
//     required this.listPoints,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: statusNotifier,
//       builder: (context, currentStatus, child) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: listStatus
//                   .map(
//                     (status) => FaceStatusWidget(
//                       status: status,
//                       isSelected: currentStatus == status,
//                       onTap: () => statusNotifier.value = status,
//                     ),
//                   )
//                   .toList(),
//             ),
//             const SizedBox(height: 16),
//             if (currentStatus == listStatus.last) ...[
//               Text(
//                 'Beri Extra Poin',
//                 style: kTextTheme.bodyLarge?.copyWith(
//                   fontWeight: FontWeight.w500,
//                   color: Palette.purple80,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               ValueListenableBuilder(
//                 valueListenable: pointNotifier,
//                 builder: (context, currentPoint, child) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: listPoints
//                         .map(
//                           (point) => ExtraPointWidget(
//                             point: point,
//                             isSelected: currentPoint == point,
//                             onTap: () => pointNotifier.value = point,
//                           ),
//                         )
//                         .toList(),
//                   );
//                 },
//               ),
//             ] else ...[
//               TextField(
//                 controller: noteController,
//                 textCapitalization: TextCapitalization.sentences,
//                 textInputAction: TextInputAction.done,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   floatingLabelBehavior: FloatingLabelBehavior.never,
//                   hintText: 'Tambahkan catatan',
//                   hintStyle: kTextTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.w400,
//                     color: Palette.greyDark.withOpacity(.5),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(
//                       color: Palette.greyDark,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(
//                       color: Palette.greyDark,
//                     ),
//                   ),
//                 ),
//                 style: kTextTheme.bodyLarge?.copyWith(
//                   color: Palette.greyDark,
//                 ),
//               ),
//             ],
//           ],
//         );
//       },
//     );
//   }
// }

// class FaceStatusWidget extends StatelessWidget {
//   final FaceStatus status;
//   final bool isSelected;
//   final VoidCallback? onTap;

//   const FaceStatusWidget({
//     super.key,
//     required this.status,
//     this.isSelected = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//             color: Palette.grey10,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: isSelected ? status.color : Palette.grey10,
//             ),
//           ),
//           child: GestureDetector(
//             onTap: onTap,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: SvgPicture.asset(
//                 AssetPath.getIcon(status.icon),
//                 color: isSelected ? status.color : Palette.grey50,
//                 width: 30,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           status.status,
//           style: kTextTheme.bodyMedium?.copyWith(
//             color: isSelected ? status.color : Palette.grey50,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ExtraPointWidget extends StatelessWidget {
//   final int point;
//   final bool isSelected;
//   final VoidCallback? onTap;

//   const ExtraPointWidget({
//     super.key,
//     required this.point,
//     this.isSelected = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CircleBorderContainer(
//       size: 32,
//       borderColor: isSelected ? Palette.purple80 : null,
//       fillColor: isSelected ? Palette.purple60 : null,
//       onTap: onTap,
//       child: Text(
//         '+$point',
//         style: kTextTheme.bodyMedium?.copyWith(
//           color: isSelected ? Palette.white : Palette.greyDark,
//         ),
//       ),
//     );
//   }
// }

// class FaceStatus {
//   final String status;
//   final String icon;
//   final Color color;

//   const FaceStatus({
//     required this.status,
//     required this.icon,
//     required this.color,
//   });
// }
