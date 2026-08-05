import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_tab_notifier.g.dart';

/// The two lists the feed switches between.
///
/// Both render the same card; they differ in what the query is — a radius
/// around the device versus the caller's own submissions.
enum FeedTab {
  nearby(label: 'Nearby'),
  mine(label: 'My reports');

  const FeedTab({required this.label});

  final String label;
}

/// Which segment of the feed is showing. Lives outside the page so switching
/// tabs does not rebuild the whole screen, only what watches this.
@riverpod
class FeedTabSelection extends _$FeedTabSelection {
  @override
  FeedTab build() => FeedTab.nearby;

  void select(FeedTab tab) {
    if (state == tab) return;

    state = tab;
  }
}
