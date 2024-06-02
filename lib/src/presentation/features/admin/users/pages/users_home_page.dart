// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/src/presentation/shared/providers/manual_providers/search_provider.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_fab.dart';
import 'package:asco/src/presentation/shared/widgets/custom_filter_chip.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/search_field.dart';

final selectedRoleProvider = StateProvider.autoDispose<String>((ref) => '');

class UsersHomePage extends ConsumerWidget {
  const UsersHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userRoleMap = {
      'Semua': '',
      'Asisten': 'assistant',
      'Praktikan': 'student',
    };

    final query = ref.watch(queryProvider);
    final selectedRole = ref.watch(selectedRoleProvider);
    final labels = userRoleMap.keys.toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Data Pengguna',
        action: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_list_rounded),
          tooltip: 'Urutkan',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Palette.scaffoldBackground,
            surfaceTintColor: Palette.scaffoldBackground,
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: SearchField(
                text: query,
                hintText: '',
                onChanged: (value) => ref.read(queryProvider.notifier).state = value,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(76),
              child: SizedBox(
                height: 60,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CustomFilterChip(
                      label: labels[index],
                      selected: selectedRole == userRoleMap[labels[index]],
                      onSelected: (_) {
                        ref.read(queryProvider.notifier).state = '';
                        ref.read(selectedRoleProvider.notifier).state = userRoleMap[labels[index]]!;
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemCount: userRoleMap.length,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 9 ? 0 : 8,
                    ),
                    // child: UserCard(),
                  );
                },
                childCount: 10,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {},
        tooltip: 'Tambah',
        child: const Icon(
          Icons.add_rounded,
          size: 28,
        ),
      ),
    );
  }
}

// class UserCard extends StatelessWidget {
//   final DetailProfileEntity profileData;
//   const UserCard({
//     required this.profileData,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWellContainer(
//       color: Colors.white,
//       onTap: () {
//         showAdminUserDetailPage(context: context);
//       },
//       margin: const EdgeInsets.only(bottom: 8),
//       radius: 12,
//       child: Container(
//         width: AppSize.getAppWidth(context),
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundImage: AssetImage(AssetPath.getImage('avatar1.jpg')),
//             ),
//             const SizedBox(
//               width: 12,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     profileData.userRole!.id! == 1
//                         ? profileData.username ?? ''
//                         : '@${profileData.username}',
//                     style: kTextTheme.bodyMedium?.copyWith(
//                       color: Palette.purple60,
//                       height: 1.1,
//                     ),
//                   ),
//                   Text(
//                     profileData.fullName ?? '',
//                     style: kTextTheme.bodyLarge?.copyWith(
//                       color: Palette.purple80,
//                       fontWeight: FontWeight.w600,
//                       height: 1.1,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 6,
//                   ),
//                   BuildBadge(
//                     badgeHelper: TempBadgeHelper(
//                         badgeId: profileData.userRole!.id! == 1 ? 3 : 4,
//                         title: profileData.userRole!.name!),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               width: 4,
//             ),
//             Column(
//               children: [
//                 SizedBox(
//                   width: 30,
//                   height: 30,
//                   child: IconButton(
//                     style: IconButton.styleFrom(
//                       backgroundColor: Palette.purple70,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                           8,
//                         ),
//                       ),
//                       padding: EdgeInsets.zero,
//                     ),
//                     onPressed: () {
//                       showAdminCreateUserPage(context: context, isEdit: true, profile: profileData);
//                     },
//                     icon: const Icon(
//                       Icons.edit,
//                       color: Palette.white,
//                       size: 18,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 SizedBox(
//                   width: 30,
//                   height: 30,
//                   child: IconButton(
//                     style: IconButton.styleFrom(
//                       backgroundColor: Palette.purple80,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                           8,
//                         ),
//                       ),
//                       padding: EdgeInsets.zero,
//                     ),
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.delete,
//                       color: Palette.white,
//                       size: 18,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
