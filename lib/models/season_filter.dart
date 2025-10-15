enum SeasonFilter {
  all('All'), // << TAMBAHKAN INI
  summer('Summer'),
  winter('Winter'),
  autumn('Autumn'),
  spring('Spring');

  const SeasonFilter(this.label);

  final String label;
}
