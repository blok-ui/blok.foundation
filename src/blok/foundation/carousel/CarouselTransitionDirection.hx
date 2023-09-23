package blok.foundation.carousel;

enum abstract CarouselTransitionDirection(Int) to Int {
  final Pending = 0;
  final Previous = -1;
  final Next = 1;
}
