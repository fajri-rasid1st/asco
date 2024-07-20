// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/excel_helper.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AttendanceListHomePage extends StatelessWidget {
  const AttendanceListHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pemrograman Mobile A',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FilledButton.icon(
              onPressed: () => exportToExcel(context),
              icon: SvgAsset(
                AssetPath.getIcon('file_excel_outlined.svg'),
              ),
              label: const Text('Export ke Excel'),
            ).fullWidth(),
            const SizedBox(height: 16),
            ...List<Padding>.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == 4 ? 0 : 10,
                ),
                // child: AttendanceCard(
                //   attendanceType: AttendanceType.meeting,
                //   meetingStatus: const {
                //     'Hadir': 18,
                //     'Alpa': 4,
                //     'Sakit': 3,
                //   },
                //   onTap: () => navigatorKey.currentState!.pushNamed(attendanceDetailRoute),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> exportToExcel(BuildContext context) async {
    final excelBytes = ExcelHelper.createAttendanceData(
      data: [
        {
          'username': 'H071211074',
          'fullname': 'Wd. Ananda Lesmono',
          'attendanceStatus': ['present', 'sick'],
        },
        {
          'username': 'H071211051',
          'fullname': 'Febi Fiantika',
          'attendanceStatus': ['absent', 'excused'],
        },
      ],
      totalAttendances: 2,
    );

    if (excelBytes != null) {
      if (await FileService.saveFileFromRawBytes(
        excelBytes,
        name: 'Kehadiran_Pemrograman_Mobile_A.xlsx',
      )) {
        if (!context.mounted) return;

        context.showSnackBar(
          title: 'Berhasil',
          message: 'Data kehadiran kelas berhasil diekspor pada folder Download.',
        );

        return;
      }
    }

    if (!context.mounted) return;

    context.showSnackBar(
      title: 'Terjadi Kesalahan',
      message: 'Data kehadiran kelas gagal diekspor.',
      type: SnackBarType.error,
    );
  }
}
