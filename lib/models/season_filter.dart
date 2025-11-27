enum SeasonFilter {
  all('All'),
  summer('Summer'),
  winter('Winter'),
  autumn('Autumn'),
  spring('Spring');

  const SeasonFilter(this.label);

  final String label;
}
