// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';
import 'package:law_app/features/admin/data/models/reference_models/discussion_category_model.dart';
import 'package:law_app/features/admin/presentation/reference/providers/discussion_category_provider.dart';
import 'package:law_app/features/library/presentation/providers/book_category_provider.dart';

class CategoryHelper {
  static Future<List<DiscussionCategoryModel>> getDiscussionCategories(WidgetRef ref) async {
    List<DiscussionCategoryModel>? categories;

    try {
      categories = await ref.watch(discussionCategoryProvider.future);
    } catch (e) {
      debugPrint('$e');
    }

    return categories ?? [];
  }

  static Future<List<BookCategoryModel>> getBookCategories(WidgetRef ref) async {
    List<BookCategoryModel>? categories;

    try {
      categories = await ref.watch(bookCategoryProvider.future);
    } catch (e) {
      debugPrint('$e');
    }

    return categories ?? [];
  }
}
