class Semigrupa {
  String id;
  String name;
  String grupa;

  Semigrupa(this.id, this.name, this.grupa);

  @override
  String toString() {
    return "Semigrupa ${name.toUpperCase()}";
  }
}
