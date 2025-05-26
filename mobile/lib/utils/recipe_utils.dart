List<String> splitInstructions(String raw) => raw
    .split(RegExp(r'(?<=\.)\s+'))
    .map((s) => s.trim())
    .where((s) => s.isNotEmpty)
    .toList();
