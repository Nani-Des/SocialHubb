class Area {
  String area;
  int area_code;
  bool checked = false;

  Area({required this.area, required this.area_code});

  set set_checked(check) {
    checked = check;
  }
}

class AreaData {
  static List<Area> areas = [
    Area(area: "Administrative law", area_code: 1),
    Area(area: "Admiralty and Maritime Law", area_code: 2),
    Area(area: "Advertising", area_code: 3),
    Area(area: "Agency, Distribution and Licensing ", area_code: 4),
    Area(area: "Antitrust and Competition", area_code: 5),
    Area(area: "Arbitration, Dispute Resolution & Mediation", area_code: 6),
    Area(area: "Aviation and aerospace", area_code: 7),
    Area(area: "Banking Law", area_code: 8),
    Area(area: "Business Crime", area_code: 9),
    Area(area: "Charities and foundation", area_code: 10),
    Area(area: "Civil Rights", area_code: 11),
    Area(area: "Commercial Law", area_code: 12),
    Area(area: "Commercial Propery", area_code: 13),
    Area(area: "Constitutional Law", area_code: 14),
    Area(area: "Construction Law", area_code: 15),
    Area(area: "Contracts", area_code: 16),
    Area(area: "Criminal Law", area_code: 17),
    Area(area: "Cultural Property", area_code: 18),
    Area(area: "Customs and Excise", area_code: 19),
    Area(area: "Debt and Creditor", area_code: 20),
    Area(area: "Employment Benefits", area_code: 21),
    Area(area: "Energy", area_code: 22),
    Area(area: "Entertainment and Sports", area_code: 23),
    Area(area: "Environmental Law", area_code: 23),
    Area(area: "European Union Law", area_code: 24),
    Area(area: "Family Law", area_code: 25),
    Area(area: "Cyber Law", area_code: 26),
    Area(area: "Finance", area_code: 27),
    Area(area: "Foreign Investment", area_code: 28),
    Area(area: "Franchising", area_code: 29),
    Area(area: "General Practice", area_code: 30),
    Area(area: "Government", area_code: 31),
    Area(area: "Government Contracts", area_code: 32),
    Area(area: "Health and Safety", area_code: 33),
    Area(area: "Human Rights Law", area_code: 34),
    Area(area: "Immigration and Nationality", area_code: 35),
    Area(area: "Information Technology (IT) Law", area_code: 36),
    Area(area: "Insolvency, Liquidation & Corporate Rescue", area_code: 37),
    Area(area: "Intellectual Property Law", area_code: 38),
    Area(area: "International Law", area_code: 39),
    Area(area: "International Trade", area_code: 40),
    Area(area: "Internet Law", area_code: 41),
    Area(area: "Labour and Employment", area_code: 42),
    Area(area: "Legal Malpractice", area_code: 43),
    Area(area: "Litigation", area_code: 44),
    Area(area: "Medicine and Ethics", area_code: 45),
    Area(area: "Mergers and Acquisitions", area_code: 46),
    Area(area: "Natural Resources", area_code: 47),
    Area(area: "Pensions", area_code: 48),
    Area(area: "Personal Injury", area_code: 49),
    Area(area: "Practice Management and Development", area_code: 50),
    Area(area: "Products Liability", area_code: 51),
    Area(area: "Professional Liability", area_code: 52),
    Area(area: "Project Finance", area_code: 53),
    Area(area: "Real State", area_code: 54),
    Area(area: "Securities", area_code: 55),
    Area(area: "Taxation", area_code: 56),
    Area(area: "Technology & Science", area_code: 57),
    Area(area: "Transportation", area_code: 58),
    Area(area: "Trusts and Estates", area_code: 59),
    Area(area: "Zoning, Planning and Land use", area_code: 60),
    Area(area: "Chieftaincy", area_code: 61),
    Area(area: "National Security Law", area_code: 62),
    Area(area: "Maritime Law", area_code: 63),
  ];
}
