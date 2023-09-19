
extension CapitalizeWords on String {
  String capitalizeWords() {
    List<String> words = split(" ");
    for(int i = 0; i < words.length; i++) {
      if(words[i].isNotEmpty) {
        words[i]  = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(" ");
  }
}
