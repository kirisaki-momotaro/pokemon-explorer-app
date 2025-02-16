class Pokemon {
  final int id;
  final String name;
  final String spriteUrl;
  final List<String> types;
  final String description;
  final int hp;
  final int attack;
  final int defense;

  Pokemon({
    required this.id,
    required this.name,
    required this.spriteUrl,
    required this.types,
    required this.description,
    required this.hp,
    required this.attack,
    required this.defense,
  });
}
