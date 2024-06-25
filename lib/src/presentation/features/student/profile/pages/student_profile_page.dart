// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr/qr.dart';

// Project imports:
import 'package:asco/core/configs/app_configs.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/asco_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/pretty_qr_code.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cardKey = GlobalKey<FlipCardState>();

    return Scaffold(
      backgroundColor: const Color(0xFF311D66),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ID Card',
                      style: textTheme.headlineSmall!.copyWith(
                        color: Palette.background,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomIconButton(
                    'edit_outlined.svg',
                    tooltip: 'Edit Profil',
                    onPressed: () => navigatorKey.currentState!.pushNamed(editProfileRoute),
                  ),
                ],
              ),
              Expanded(
                child: FlipCard(
                  key: cardKey,
                  flipOnTouch: false,
                  front: const IdCardFrontSide(),
                  back: const IdCardBackSide(),
                ),
              ),
              InkWellContainer(
                width: 64,
                height: 64,
                radius: 32,
                color: Palette.purple2,
                border: Border.all(
                  width: 2,
                  color: Palette.background,
                ),
                onTap: () => cardKey.currentState!.toggleCard(),
                child: Center(
                  child: SvgAsset(
                    AssetPath.getIcon('flip_card.svg'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IdCardFrontSide extends StatelessWidget {
  const IdCardFrontSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      decoration: BoxDecoration(
        color: Palette.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Palette.purple1,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const SizedBox(height: 160),
                  Container(
                    height: 6,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Palette.violet2,
                          Palette.violet4,
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Palette.purple2,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: RotatedBox(
                quarterTurns: -2,
                child: SvgAsset(
                  AssetPath.getVector('bg_attribute.svg'),
                  width: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Positioned(
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: AscoAppBar(),
              ),
            ),
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 98),
                  Center(
                    child: Container(
                      width: 100,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Palette.purple5,
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          width: 4,
                          color: const Color(0xFF48299A),
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://placehold.co/300x300/png',
                        fadeInDuration: const Duration(milliseconds: 200),
                        fadeOutDuration: const Duration(milliseconds: 200),
                        fit: BoxFit.fitHeight,
                        placeholder: (context, url) {
                          return const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: SpinKitRing(
                                lineWidth: 2,
                                color: Palette.secondaryText,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return const Center(
                            child: Icon(
                              Icons.hide_source_rounded,
                              color: Palette.secondaryText,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'H071191049',
                            style: textTheme.titleMedium!.copyWith(
                              color: Palette.violet3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Rafly Ramdhani Putra Masloman',
                            style: textTheme.titleLarge!.copyWith(
                              color: Palette.background,
                              height: 1.25,
                            ),
                          ),
                          Text(
                            '(Rafly)',
                            style: textTheme.bodySmall!.copyWith(
                              color: Palette.violet3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'SISTEM INFORMASI 21',
                            style: textTheme.bodyLarge!.copyWith(
                              color: Palette.background,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              SvgAsset(
                                AssetPath.getIcon('github_filled.svg'),
                                color: Palette.background,
                                width: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'github.com/bayu-ajid',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall!.copyWith(
                                    color: Palette.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              SvgAsset(
                                AssetPath.getIcon('instagram_filled.svg'),
                                width: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'instagram.com/bayuajid_',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall!.copyWith(
                                    color: Palette.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IdCardBackSide extends StatelessWidget {
  const IdCardBackSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      decoration: BoxDecoration(
        color: Palette.purple2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Palette.purple1,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SvgAsset(
                AssetPath.getVector('bg_attribute.svg'),
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: RotatedBox(
                quarterTurns: -2,
                child: SvgAsset(
                  AssetPath.getVector('bg_attribute.svg'),
                  width: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 48,
                  horizontal: 20,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Palette.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Scan QR di bawah dengan\t',
                        style: textTheme.bodyLarge!.copyWith(
                          color: Palette.purple2,
                          height: 1.25,
                        ),
                        children: [
                          TextSpan(
                            text: AppConfigs.title,
                            style: textTheme.titleMedium!.copyWith(
                              color: Palette.violet1,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PrettyQrCode(
                          data: 'H071191051',
                          roundedEdges: true,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                          color: Palette.purple2,
                        ),
                      ),
                    ),
                    Text(
                      'Rafly Ramdhani Putra Masloman',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium!.copyWith(
                        color: Palette.purple2,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'H071191049',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall!.copyWith(
                        color: Palette.purple3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
