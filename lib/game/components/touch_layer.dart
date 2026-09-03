import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../puff_game.dart';

/// Full-screen, invisible viewport component that forwards raw drag events
/// to the game's [TouchController]. Flutter overlays (menus) sit above the
/// GameWidget, so they naturally block these events.
class TouchLayer extends PositionComponent
    with DragCallbacks, HasGameReference<PuffGame> {
  TouchLayer() : super(priority: 1000);

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    game.onPointerDown(event.pointerId, event.canvasPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    game.onPointerMove(event.pointerId, event.canvasEndPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    game.onPointerUp(event.pointerId);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    game.onPointerCancel(event.pointerId);
  }
}
