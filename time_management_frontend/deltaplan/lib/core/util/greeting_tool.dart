class GreetingTool {
  static String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour > 0 && hour < 4) {
      return 'Good night! 💫';
    }
    if (hour < 12) {
      return 'Good morning! 🌤️';
    }
    if (hour < 17) {
      return 'Good afternoon! ☀️';
    }
    return 'Good evening! 🌙';
  }
}
