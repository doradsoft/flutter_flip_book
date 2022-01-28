class HtmlDocument {
  final HtmlDocumentElement? documentElement = HtmlDocumentElement();
  exitFullscreen() {}
}

class HtmlDocumentElement {
  requestFullscreen() {}
  ElementStream<Event> get onFullscreenChange => ElementStream<Event>();
}

class Event {}

class ElementStream<T> {}

final HtmlDocument document = HtmlDocument();
