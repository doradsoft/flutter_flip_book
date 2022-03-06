class AspectRatioFraction {
  final double widthFactor;
  final double heightFactor;

  double get value => widthFactor / heightFactor;

  const AspectRatioFraction(this.widthFactor, this.heightFactor);
}
