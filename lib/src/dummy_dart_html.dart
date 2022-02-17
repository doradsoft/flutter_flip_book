class HtmlDocument {
  HtmlDocumentElement? fullscreenElement;
  final HtmlDocumentElement? documentElement = HtmlDocumentElement();
  exitFullscreen() {}
}

class HtmlDocumentElement {
  requestFullscreen() {}
  ElementStream<Event> get onFullscreenChange => ElementStream<Event>();
}

class Event {}

class ElementStream<T> {
  void listen(event) {}
}

final HtmlDocument document = HtmlDocument();
