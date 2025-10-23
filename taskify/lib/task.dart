class task { final  String title;
  bool isDone;
  task({this.isDone = false , required this.title});
  void toggleDone(){
    isDone = !isDone;
  }
}
