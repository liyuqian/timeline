import "dart:ui" as ui;
import 'dart:ui';
import "package:nima/nima.dart" as nima;
import "package:nima/nima/animation/actor_animation.dart" as nima;
import "package:nima/nima/math/aabb.dart" as nima;
import "package:flare/flare.dart" as flare;
import "package:flare/flare/animation/actor_animation.dart" as flare;
import "package:flare/flare/math/aabb.dart" as flare;
import "package:flare/flare/math/vec2d.dart" as flare;

class TimelineImage extends TimelineAsset {
  ui.Image image;
}

class TimelineAnimatedAsset extends TimelineAsset {
  double animationTime = 0.0;
  bool loop;
  double offset = 0.0;
  double gap = 0.0;
}

class TimelineNima extends TimelineAnimatedAsset {
  nima.FlutterActor actorStatic;
  nima.FlutterActor actor;
  nima.ActorAnimation animation;
  nima.AABB setupAABB;
}

class TimelineFlare extends TimelineAnimatedAsset {
  flare.FlutterActorArtboard actorStatic;
  flare.FlutterActorArtboard actor;
  flare.ActorAnimation animation;

  flare.ActorAnimation intro;
  flare.ActorAnimation idle;
  List<flare.ActorAnimation> idleAnimations;

  flare.AABB setupAABB;
}

class TimelineAsset {
  double width;
  double height;
  double opacity = 0.0;
  double scale = 0.0;
  double scaleVelocity = 0.0;
  double y = 0.0;
  double velocity = 0.0;
  String filename;
  TimelineEntry entry;
}

enum TimelineEntryType { Era, Incident }

class TimelineEntry {
  TimelineEntryType type;
  double start;
  double end;
  String _label;
  int lineCount = 1;
  String get label => _label;
  set label(String value) {
    _label = value;
    int start = 0;
    lineCount = 1;
    while (true) {
      start = _label.indexOf("\n", start);
      if (start == -1) {
        break;
      }
      lineCount++;
      start++;
    }
  }

  String articleFilename;
  String id;

  Color accent;

  TimelineEntry parent;
  List<TimelineEntry> children;
  TimelineEntry next;
  TimelineEntry previous;

  double y = 0.0;
  double endY = 0.0;
  double length = 0.0;
  double opacity = 0.0;
  double labelOpacity = 0.0;
  double targetLabelOpacity = 0.0;
  double delayLabel = 0.0;
  double targetAssetOpacity = 0.0;
  double delayAsset = 0.0;
  double legOpacity = 0.0;
  double labelY = 0.0;
  double labelVelocity = 0.0;
  double favoriteY = 0.0;
  bool isFavoriteOccluded = false;

  bool get isVisible {
    return opacity > 0.0;
  }

  TimelineAsset asset;

  String formatYearsAgo() {
    if (start > 0) {
      return start.round().toString();
    }
    return TimelineEntry.formatYears(start) + " Ago";
  }

  @override
  String toString() {
    return "TIMELINE ENTRY: $label -($start,$end)";
  }

  static String formatYears(double start) {
    String label;
    int valueAbs = start.round().abs();
    if (valueAbs > 1000000000) {
      double v = (valueAbs / 100000000.0).floorToDouble() / 10.0;

      label = (valueAbs / 1000000000)
              .toStringAsFixed(v == v.floorToDouble() ? 0 : 1) +
          " Billion";
    } else if (valueAbs > 1000000) {
      double v = (valueAbs / 100000.0).floorToDouble() / 10.0;
      label =
          (valueAbs / 1000000).toStringAsFixed(v == v.floorToDouble() ? 0 : 1) +
              " Million";
    } else if (valueAbs > 10000) // N.B. < 10,000
    {
      double v = (valueAbs / 100.0).floorToDouble() / 10.0;
      label =
          (valueAbs / 1000).toStringAsFixed(v == v.floorToDouble() ? 0 : 1) +
              " Thousand";
    } else {
      label = valueAbs.toStringAsFixed(0);
    }
    return label + " Years";
  }
}
