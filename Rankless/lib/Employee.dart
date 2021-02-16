class Employee {
  String name;
  String lastname;
  String email;
  List<String> roles;
  //List<Komentar> comments;
  //List<Survey> surveys;

  Employee(this.name, this.lastname, {this.roles});

  Future<void> createData() async {
    //TODO connect to firebase
  }

  Future<void> getData() async {}

  Future<void> updateData() async {}
}
