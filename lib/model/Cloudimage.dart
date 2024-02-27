getWeatherImage(String imagecode) {
  switch (imagecode) {
    case '01d':
      return "./assets/cloud.png";
    case '01n':
      return "./assets/cloud.png";
    case '02d':
    case '02n':
      return "./assets/02dn.png";
    case '03d':
    case '03n':
      return "./assets/03dn.png";
    case '04d':
    case '04n':
      return "./assets/04dn.png";
    case '09d':
    case '09n':
      return "./assets/09dn.png";
    case '10d':
    case '10n':
      return "./assets/10dn.png";
    case '11d':
    case '11n':
      return "./assets/11dn.png";
    case '13d':
    case '13n':
      return "./assets/13dn.png";

    default:
      return "./assets/cloud.png"; // Default icon if code doesn't match
  }
}
