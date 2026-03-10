import 'dart:io';

void main() {

  final Map<String, Map<String, int>> journal = {
    'Bolotskiy': {'ОСиС': 5, 'Питон': 4, 'Джава': 5, 'Психология': 5},
    'Lozovoy': {'ОСиС': 4, 'Питон': 4, 'Джава': 5, 'Психология': 5},
    'Merzaev': {'ОСиС': 4, 'Питон': 4, 'Джава': 4, 'Психология': 5},
    'Isahanin': {'ОСиС': 3, 'Питон': 5, 'Джава': 5, 'Психология': 5},
    'Sinegribov': {'ОСиС': 5, 'Питон': 5, 'Джава': 5, 'Психология': 5},
    'Hrustalev': {'ОСиС': 5, 'Питон': 4, 'Джава': 2, 'Психология': 5},
  };

  final List<String> subjects = ['ОСиС', 'Питон', 'Джава', 'Психология'];

  print('---- РАСШИРЕННЫЙ ОТЧЁТ ПО ГРУППЕ ----');

  printTable(journal, subjects);

  searchStudent(journal, subjects);

  uniqueGrades(journal);

  minMaxSubjects(journal);

  studentParasha(journal, subjects);

  lionsInStudents(journal, subjects);

  castsStudents(journal);
}

void printTable(Map<String, Map<String, int>> journal, List<String> subjects) {
  print('СВОДНАЯ ТАБЛИЦА ОЦЕНОК');
  print('-' * 80);
  
  stdout.write('${'Студент'.padRight(15)}');
  for (var subject in subjects) {
    stdout.write('${subject.padRight(12)}');
  }
  print('Средний');
  print('-' * 80);

  for (var student in journal.keys) {
    stdout.write('${student.padRight(15)}');
    double sum = 0;
    int count = 0;
    
    for (var subject in subjects) {
      var grade = journal[student]?[subject] ?? 0;
      if (grade > 0) {
        stdout.write('${grade.toString().padRight(12)}');
        sum += grade;
        count++;
      } else {
        stdout.write('${'-'.padRight(12)}');
      }
    }
    
    double average;
    if (count > 0) {
      average = sum / count;
    } else {
      average = 0;
    }

    print('${average.toStringAsFixed(2).padRight(10)}');
  }
  
  print('-' * 80);
  stdout.write('${'Средний по пр.'.padRight(15)}');
  
  for (var subject in subjects) {
    double sum = 0;
    int count = 0;
    for (var student in journal.keys) {
      var grade = journal[student]?[subject] ?? 0;
      if (grade > 0) {
        sum += grade;
        count++;
      }
    }

    double average;
    if (count > 0) {
      average = sum / count;
    } else {
      average = 0;
    }
    stdout.write('${average.toStringAsFixed(2).padRight(12)}');
  }

  print('\n');
}

void searchStudent(Map<String, Map<String, int>> journal, List<String> subjects) {
  print('---- ПОИСК СТУДЕНТА ----');
  stdout.write('Введите фамилию студента: ');
  
  String? raw = stdin.readLineSync();

  if (raw == null || raw.isEmpty) {
    print('Неверный ввод');
    return;
  }
  
  String input = raw.trim();
  
  if (input.isEmpty) {
    print('Пусто\n');
    return;
  }
  
  String student = '';
  for (var s in journal.keys) {
    if (s.toLowerCase() == input.toLowerCase()) {
    student = s;
    break;
    }
  }
  
  if (student.isEmpty) {
    print('Студент "$input" не найден.');
    return;
  }
  
  print('-' * 50);
  
  double sum = 0;
  int count = 0;
  
  for (var subject in subjects) {
    var grade = journal[student]?[subject];
    if (grade != null) {
      print('$subject: $grade');
      sum += grade;
      count++;
    }
  }
  
  double average;
    if (count > 0) {
      average = sum / count;
    } else {
      average = 0;
    }

  print('\nСредний балл: ${average.toStringAsFixed(2)}');
  
  String category = average >= 4.5 ? 'Отличник' : 
                    average >= 3.5 ? 'Хорошист' : 
                    'Остальные';
  print('Категория: $category\n');
}

void uniqueGrades(Map<String, Map<String, int>> journal) {
  print('---- ОЦЕНКИ, ВСТРЕЧАЮЩИЕСЯ РОВНО 1 РАЗ ----');
  
  Map<int, int> gradeFrequency = {};
  
  for (var student in journal.values) {
    for (var grade in student.values) {
      gradeFrequency[grade] = (gradeFrequency[grade] ?? 0) + 1;
    }
  }
  
  List<int> singleGrades = [];
  for (var entry in gradeFrequency.entries) {
    if (entry.value == 1) {
      singleGrades.add(entry.key);
    }
  }
  
  if (singleGrades.isEmpty) {
    print('Нет уникальных оценок\n');
  } else {
    singleGrades.sort();
    print('Уникальные оценки: ${singleGrades.join(', ')}\n');
  }
}

void minMaxSubjects(Map<String, Map<String, int>> journal) {
  print('---- СТАТИСТИКА ПО ПРЕДМЕТАМ ----');
  print('-' * 50);
  
  final subjects = journal.values.first.keys.toList();
  
  for (var subject in subjects) {
    int? maxGrade, minGrade;
    List<String> maxStudents = [], minStudents = [];
    
    for (var student in journal.keys) {
      var grade = journal[student]?[subject];
      if (grade != null) {
        if (maxGrade == null || grade > maxGrade) {
          maxGrade = grade;
          maxStudents = [student];
        } else if (grade == maxGrade) {
          maxStudents.add(student);
        }
        
        if (minGrade == null || grade < minGrade) {
          minGrade = grade;
          minStudents = [student];
        } else if (grade == minGrade) {
          minStudents.add(student);
        }
      }
    }
    
    if (maxGrade != null) {
      print('$subject:');
      print('Макс: $maxGrade (${maxStudents.join(', ')})');
      print('Мин:  $minGrade (${minStudents.join(', ')})');
    }
  }
}

void studentParasha(Map<String, Map<String, int>> journal, List<String> subjects) {
  print('---- СТУДЕНТЫ С РОВНО ОДНОЙ ДВОЙКОЙ ----');
  print('-' * 50);
  
  bool found = false;
  
  for (var student in journal.keys) {
    List<String> failSubjects = [];
    
    for (var subject in subjects) {
      var grade = journal[student]?[subject];
      if (grade == 2) {
        failSubjects.add(subject);
      }
    }
    
    if (failSubjects.length == 1) {
      print('$student — двойка по предмету: ${failSubjects.first}');
      found = true;
    }
  }
  
  if (!found) print('Нет студентов с одной двойкой.');
}

void lionsInStudents(Map<String, Map<String, int>> journal, List<String> subjects) {
  print('---- ПРЕДМЕТЫ ВЫШЕ ОБЩЕГО СРЕДНЕГО ПО ГРУППЕ ----');
  print('-' * 50);
  
  double totalSum = 0;
  int totalCount = 0;
  
  for (var student in journal.values) {
    for (var grade in student.values) {
      totalSum += grade;
      totalCount++;
    }
  }
  
  double overallAverage;

  if (totalCount > 0) {
    overallAverage = totalSum / totalCount;
  } else {
    overallAverage = 0;
  }

  print('Общий средний балл по группе: ${overallAverage.toStringAsFixed(2)}\n');
  
  for (var subject in subjects) {
    double sum = 0;
    int count = 0;
    
    for (var student in journal.keys) {
      var grade = journal[student]?[subject];
      if (grade != null) {
        sum += grade;
        count++;
      }
    }
    
    if (count > 0) {
      double subjectAvg = sum / count;
      if (subjectAvg > overallAverage) {
        print('$subject: ${subjectAvg.toStringAsFixed(2)} (выше среднего на ${(subjectAvg - overallAverage).toStringAsFixed(2)})');
      }
    }
  }
}

void castsStudents(Map<String, Map<String, int>> journal) {
  print('---- РАСПРЕДЕЛЕНИЕ СТУДЕНТОВ ПО КАТЕГОРИЯМ ----');
  print('-' * 50);
  
  int excellent = 0, good = 0, other = 0;
  
  for (var student in journal.keys) {
    double sum = 0;
    int count = 0;
    
    for (var grade in journal[student]!.values) {
      sum += grade;
      count++;
    }
    
    double average;
    if (count > 0) {
      average = sum / count;
    } else {
      average = 0;
    }
    
    if (average >= 4.5) {
      excellent++;
    } else if (average >= 3.5) {
      good++;
    } else {
      other++;
    }
  }
  
  print('Отличники: $excellent');
  print('Хорошисты: $good');
  print('Остальные: $other');
}