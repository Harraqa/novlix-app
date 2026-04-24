class countries {
  final String id;
  final String title;
  final List<List<String>> countryList;
  final String imageUrl;
  final bool eurpoe;
  final bool non_europe;

  const countries({
    required this.id,
    required this.title,
    required this.countryList,
    required this.imageUrl,
    required this.eurpoe,
    required this.non_europe,
  });
}
