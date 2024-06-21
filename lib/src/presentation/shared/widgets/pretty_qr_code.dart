// Dart imports:
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:qr/qr.dart';

class PrettyQrCode extends StatelessWidget {
  final String data;
  final double? width;
  final double? height;
  final ui.Image? image;
  final int errorCorrectionLevel;
  final bool roundedEdges;
  final Color color;
  final Color backgroundColor;

  const PrettyQrCode({
    super.key,
    required this.data,
    this.width,
    this.height,
    this.image,
    this.errorCorrectionLevel = QrErrorCorrectLevel.M,
    this.roundedEdges = false,
    this.color = Colors.black,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return CustomPaint(
          size: Size(
            width ?? constraint.maxWidth,
            height ?? constraint.maxHeight,
          ),
          painter: PrettyQrCodePainter(
            data: data,
            image: image,
            errorCorrectLevel: errorCorrectionLevel,
            roundedEdges: roundedEdges,
            elementColor: color,
            backgroundColor: backgroundColor,
          ),
        );
      },
    );
  }
}

class PrettyQrCodePainter extends CustomPainter {
  final String data;
  final int errorCorrectLevel;
  final bool roundedEdges;
  final Color elementColor;
  final Color backgroundColor;
  final ui.Image? image;

  late final QrCode _qrCode;
  late final QrImage _qrImage;

  int deletePixelCount = 0;

  PrettyQrCodePainter({
    required this.data,
    required this.errorCorrectLevel,
    required this.roundedEdges,
    required this.elementColor,
    required this.backgroundColor,
    this.image,
    int? typeNumber,
  }) {
    if (typeNumber == null) {
      _qrCode = QrCode.fromData(
        data: data,
        errorCorrectLevel: errorCorrectLevel,
      );
    } else {
      _qrCode = QrCode(typeNumber, errorCorrectLevel)..addData(data);
    }

    _qrImage = QrImage(_qrCode);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      if (_qrImage.typeNumber <= 2) {
        deletePixelCount = _qrImage.typeNumber + 7;
      } else if (_qrImage.typeNumber <= 4) {
        deletePixelCount = _qrImage.typeNumber + 8;
      } else {
        deletePixelCount = _qrImage.typeNumber + 9;
      }

      final imageSize = Size(image!.width.toDouble(), image!.height.toDouble());

      final src = Alignment.center.inscribe(
        imageSize,
        Rect.fromLTWH(
          0,
          0,
          image!.width.toDouble(),
          image!.height.toDouble(),
        ),
      );

      final dst = Alignment.center.inscribe(
        Size(size.height / 4, size.height / 4),
        Rect.fromLTWH(
          size.width / 3,
          size.height / 3,
          size.height / 3,
          size.height / 3,
        ),
      );

      canvas.drawImageRect(image!, src, dst, Paint());
    }

    roundedEdges ? _paintRound(canvas, size) : _paintDefault(canvas, size);
  }

  void _paintRound(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = elementColor
      ..isAntiAlias = true;

    final paintBackground = Paint()
      ..style = PaintingStyle.fill
      ..color = backgroundColor
      ..isAntiAlias = true;

    final List<List?> matrix = []..length = _qrImage.moduleCount + 2;

    for (var i = 0; i < _qrImage.moduleCount + 2; i++) {
      matrix[i] = []..length = _qrImage.moduleCount + 2;
    }

    for (var x = 0; x < _qrImage.moduleCount + 2; x++) {
      for (var y = 0; y < _qrImage.moduleCount + 2; y++) {
        matrix[x]![y] = false;
      }
    }

    for (var x = 0; x < _qrImage.moduleCount; x++) {
      for (var y = 0; y < _qrImage.moduleCount; y++) {
        if (image != null &&
            x >= deletePixelCount &&
            y >= deletePixelCount &&
            x < _qrImage.moduleCount - deletePixelCount &&
            y < _qrImage.moduleCount - deletePixelCount) {
          matrix[y + 1]![x + 1] = false;

          continue;
        }

        if (_qrImage.isDark(y, x)) {
          matrix[y + 1]![x + 1] = true;
        } else {
          matrix[y + 1]![x + 1] = false;
        }
      }
    }

    final pixelSize = size.width / _qrImage.moduleCount;

    for (var x = 0; x < _qrImage.moduleCount; x++) {
      for (var y = 0; y < _qrImage.moduleCount; y++) {
        if (matrix[y + 1]![x + 1]) {
          final squareRect = Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize);

          _setShape(
            x + 1,
            y + 1,
            squareRect,
            paint,
            matrix,
            canvas,
            _qrImage.moduleCount,
          );
        } else {
          _setShapeInner(
            x + 1,
            y + 1,
            paintBackground,
            matrix,
            canvas,
            pixelSize,
          );
        }
      }
    }
  }

  void _drawCurve(Offset p1, Offset p2, Offset p3, Canvas canvas) {
    final path = Path();

    path.moveTo(p1.dx, p1.dy);
    path.quadraticBezierTo(p2.dx, p2.dy, p3.dx, p3.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p1.dx, p1.dy);
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = elementColor,
    );
  }

  void _setShapeInner(
    int x,
    int y,
    Paint paint,
    List matrix,
    Canvas canvas,
    double pixelSize,
  ) {
    final widthY = pixelSize * (y - 1);
    final heightX = pixelSize * (x - 1);

    // Bottom right check
    if (matrix[y + 1][x] && matrix[y][x + 1] && matrix[y + 1][x + 1]) {
      final p1 = Offset(heightX + pixelSize - (0.25 * pixelSize), widthY + pixelSize);
      final p2 = Offset(heightX + pixelSize, widthY + pixelSize);
      final p3 = Offset(heightX + pixelSize, widthY + pixelSize - (0.25 * pixelSize));

      _drawCurve(p1, p2, p3, canvas);
    }

    // Top left check
    if (matrix[y - 1][x] && matrix[y][x - 1] && matrix[y - 1][x - 1]) {
      final p1 = Offset(heightX, widthY + (0.25 * pixelSize));
      final p2 = Offset(heightX, widthY);
      final p3 = Offset(heightX + (0.25 * pixelSize), widthY);

      _drawCurve(p1, p2, p3, canvas);
    }

    // Bottom left check
    if (matrix[y + 1][x] && matrix[y][x - 1] && matrix[y + 1][x - 1]) {
      final p1 = Offset(heightX, widthY + pixelSize - (0.25 * pixelSize));
      final p2 = Offset(heightX, widthY + pixelSize);
      final p3 = Offset(heightX + (0.25 * pixelSize), widthY + pixelSize);

      _drawCurve(p1, p2, p3, canvas);
    }

    // Top right check
    if (matrix[y - 1][x] && matrix[y][x + 1] && matrix[y - 1][x + 1]) {
      final p1 = Offset(heightX + pixelSize - (0.25 * pixelSize), widthY);
      final p2 = Offset(heightX + pixelSize, widthY);
      final p3 = Offset(heightX + pixelSize, widthY + (0.25 * pixelSize));

      _drawCurve(p1, p2, p3, canvas);
    }
  }

  void _setShape(
    int x,
    int y,
    Rect squareRect,
    Paint paint,
    List matrix,
    Canvas canvas,
    int n,
  ) {
    var bottomRight = false;
    var bottomLeft = false;
    var topRight = false;
    var topLeft = false;

    // If it is dot (arount an empty place)
    if (!matrix[y + 1][x] && !matrix[y][x + 1] && !matrix[y - 1][x] && !matrix[y][x - 1]) {
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          squareRect,
          bottomRight: const Radius.circular(2.5),
          bottomLeft: const Radius.circular(2.5),
          topLeft: const Radius.circular(2.5),
          topRight: const Radius.circular(2.5),
        ),
        paint,
      );

      return;
    }

    // Bottom right check
    if (!matrix[y + 1][x] && !matrix[y][x + 1]) bottomRight = true;

    // Top left check
    if (!matrix[y - 1][x] && !matrix[y][x - 1]) topLeft = true;

    // Bottom left check
    if (!matrix[y + 1][x] && !matrix[y][x - 1]) bottomLeft = true;

    // Top right check
    if (!matrix[y - 1][x] && !matrix[y][x + 1]) topRight = true;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        squareRect,
        bottomRight: bottomRight ? const Radius.circular(6.0) : Radius.zero,
        bottomLeft: bottomLeft ? const Radius.circular(6.0) : Radius.zero,
        topLeft: topLeft ? const Radius.circular(6.0) : Radius.zero,
        topRight: topRight ? const Radius.circular(6.0) : Radius.zero,
      ),
      paint,
    );

    // If it is dot (arount an empty place)
    if (!bottomLeft && !bottomRight && !topLeft && !topRight) {
      canvas.drawRect(squareRect, paint);
    }
  }

  void _paintDefault(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = elementColor
      ..isAntiAlias = true;

    // Size of point
    final pixelSize = size.width / _qrImage.moduleCount;

    for (var x = 0; x < _qrImage.moduleCount; x++) {
      for (var y = 0; y < _qrImage.moduleCount; y++) {
        if (image != null &&
            x >= deletePixelCount &&
            y >= deletePixelCount &&
            x < _qrImage.moduleCount - deletePixelCount &&
            y < _qrImage.moduleCount - deletePixelCount) continue;

        if (_qrImage.isDark(y, x)) {
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(PrettyQrCodePainter oldDelegate) => oldDelegate.data != data;
}
