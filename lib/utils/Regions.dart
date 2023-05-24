class Region {
  String region;
  int region_code;

  Region({required this.region, required this.region_code});
}

class RegionData {
  static List<Region> regions = [
    Region(region: "Greater Accra", region_code: 1),
    Region(region: "Ashanti", region_code: 2),
    Region(region: "Central", region_code: 3),
    Region(region: "Eastern", region_code: 4),
    Region(region: "Bono", region_code: 8),
    Region(region: "Bono East", region_code: 5),
    Region(region: "Western", region_code: 6),
    Region(region: "Western North", region_code: 7),
    Region(region: "Volta", region_code: 9),
    Region(region: "Savannah", region_code: 10),
    Region(region: "Upper West", region_code: 11),
    Region(region: "Upper East", region_code: 12),
    Region(region: "North East", region_code: 13),
    Region(region: "Oti", region_code: 14),
    Region(region: "Ahafo", region_code: 15),
    Region(region: "Northern", region_code: 16)
  ];
}
