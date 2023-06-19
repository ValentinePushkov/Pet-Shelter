import 'package:flutter/material.dart';

class Constants {
  static String currentUser;
  static String privateKey;
  static final searchPet = 'Поиск питомца';
  static final apply = 'Применить';
  static final resetFilters = 'Очистить фильтры';
  static final lost = 'Потерян';
  static final adopt = 'Бездомный';
  static final camera = 'Камера';
  static final chooseImage = 'Выберите изображение';
  static final catPng = 'images/cat.png';
  static final name = 'Название питомца*:';
  static final nameHint = 'Название';
  static final species = 'Порода питомца*:';
  static final speciesHint = 'Порода';
  static final age = 'Возраст питомца:';
  static final ageHint = 'Возраст';
  static final petCategory = 'Камера';
  static final description = 'Описание*:';
  static final descriptionHint = 'Описание';
  static final nfcUnavaliable =
      'Недоступен(включите NFC и перезагрузите страницу)';
  static final nfcAvaliable = 'Доступен';
  static final adNotFound = 'Объявление не найдено.';
  static final scanTag = 'Отсканируйте метку';
  static final addPicture = 'Добавьте изображение.';
  static final chooseCategory = 'Выберите категорию.';
  static final adOnModeration = 'Объявление отправлено на модерацию.';
  static final incorrectFields = 'Некорректные поля!';
  static final adAccepted = 'Объявление принято!';
  static final adDenied = 'Объявление отклонено!';
  static final savedQR = 'QR-код успешно сохранен';
  static final userNotFound = 'Пользователь не найден.';
  static final wrongPassword = 'Неверный пароль.';
  static final emailAlreadyInUse =
      'Пользователь с таким e-mail уже существует.';
  static final weakPassword = 'Слабый пароль.';
  static final finished = 'Закончено!';
  static final grey400 = Colors.grey[400];
  static final grey500 = Colors.grey[500];
  static final grey600 = Colors.grey[600];

  static final kPrimaryColor = Color(0xFFB306060);
  static final kPrimaryColorLighter = Color.fromRGBO(156, 143, 255, 0.3);
  static final kSecondaryColor =
      Color.fromRGBO(255, 195, 87, 0.8); //Color(0xFFFE9901)
  static final kContentColorLightTheme = Color(0xFF1D1D35);
  static final kContentColorDarkTheme = Color(0xFFF5FCF9);

  static final List category = ["Коты", "Псы", "Попугаи", "Кролики", "Другая"];
}
