class cities {
  final String id;
  final List<String> countries_;
  final String title;
  final List<String> imageUrl;
  final List<String> placesUrl;
  final List<String> places;
  final String timezone;

  const cities({
    required this.id,
    required this.countries_,
    required this.title,
    required this.imageUrl,
    required this.placesUrl,
    required this.places,
    required this.timezone,
  });
}
