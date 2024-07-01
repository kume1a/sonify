final englishLettersRegex = RegExp(r'^[a-zA-Z]');

bool isEnglish(String name) {
  return englishLettersRegex.hasMatch(name);
}

int compareAudioTitles(String aTitle, String bTitle) {
  // Check if names are surrounded by quotes
  final bool aIsQuoted = aTitle.startsWith('"') && aTitle.endsWith('"');
  final bool bIsQuoted = bTitle.startsWith('"') && bTitle.endsWith('"');

  // Check if names start with a number or special character
  final bool aStartsWithNonLetter = aTitle.startsWith(RegExp(r'[0-9]|\W'));
  final bool bStartsWithNonLetter = bTitle.startsWith(RegExp(r'[0-9]|\W'));

  // Prioritize English names not surrounded by quotes
  if (isEnglish(aTitle) && !aIsQuoted && isEnglish(bTitle) && bIsQuoted) {
    return -1;
  } else if (isEnglish(bTitle) && !bIsQuoted && isEnglish(aTitle) && aIsQuoted) {
    return 1;
  }

  // Then, prioritize non-English names before English names surrounded by quotes
  if (!isEnglish(aTitle) && (isEnglish(bTitle) && bIsQuoted)) {
    return -1;
  } else if (!isEnglish(bTitle) && (isEnglish(aTitle) && aIsQuoted)) {
    return 1;
  }

  // Next, prioritize titles starting with numbers or characters
  if (aStartsWithNonLetter && !bStartsWithNonLetter) {
    return 1;
  } else if (bStartsWithNonLetter && !aStartsWithNonLetter) {
    return -1;
  }

  // Lastly, sort alphabetically for names within the same category
  return aTitle.compareTo(bTitle);
}
