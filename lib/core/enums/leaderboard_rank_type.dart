enum LeaderboardRankType {
  bronze('polygon_bronze.svg'),
  silver('polygon_silver.svg'),
  gold('polygon_gold.svg');

  final String svgName;

  const LeaderboardRankType(this.svgName);
}
