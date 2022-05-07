import 'dart:typed_data';

import 'package:flame/assets.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockImages extends Mock implements Images {}

/// {@template mock_flame_images}
/// Mock for flame images instance.
///
/// Using real images blocks the tests, for this reason we need fake image
/// everywhere we use [Images.fromCache] or [Images.load].
/// {@endtemplate}
Future<void> mockFlameImages() async {
  final image = await decodeImageFromList(Uint8List.fromList(_fakeImage));
  final images = _MockImages();
  when(() => images.fromCache(any())).thenReturn(image);
  when(() => images.load(any())).thenAnswer((_) => Future.value(image));
  Flame.images = images;
}

const _fakeImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];
