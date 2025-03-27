class GoalsBean {
  final String? name;
  final String? image;
  final String? position;

  GoalsBean({this.name, this.image, this.position});

  static List<GoalsBean> goalsList() {
    var calculators = <GoalsBean>[];

    calculators.add(new GoalsBean(
        name: "Buying a Home", image: "ef_goal_home.png", position: "0"));
    calculators.add(new GoalsBean(
        name: "Child Education", image: "ef_goal_child_edu.png", position: "1"));
    calculators.add(new GoalsBean(
        name: "Retirement", image: "ef_goal_retirement.png", position: "2"));
    calculators.add(new GoalsBean(
        name: "Save Tax", image: "ef_goal_tax.png", position: "3"));
    calculators.add(new GoalsBean(
        name: "Emergency Fund", image: "ef_goal_emergency_fund.png", position: "4"));
    calculators.add(new GoalsBean(
        name: "Wedding", image: "ef_goal_wedding.png", position: "5"));

    calculators.add(new GoalsBean(
        name: "International Vacation", image: "mf_vacation.png", position: "6"));

    return calculators;
  }
}
