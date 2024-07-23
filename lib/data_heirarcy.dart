
import 'dart:convert';

class Sets_ins {
  var reps;
  var max;
  Sets_ins(this.reps, this.max);

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'max': max,
    };
  }

  factory Sets_ins.fromJson(Map<String, dynamic> json) {
    return Sets_ins(
      json['reps'],
      json['max'],
    );
  }
}

class exercise_info {
  var name;
  var Sets;
  var max_value_of_exersice = 0;
  var max_value_of_reps = 0;
  var last_time_sets = 2;
  exercise_info(this.name, var set_instance, this.last_time_sets) {
    this.Sets = set_instance;

    for (var i = 0; i < Sets.length; i++) {
      if (max_value_of_exersice < Sets[i].max) {
        max_value_of_exersice = Sets[i].max;
      }
      if (max_value_of_reps < Sets[i].reps) {
        max_value_of_reps = Sets[i].reps;
      }

      print("New max lift : $max_value_of_exersice\n");
      print("New max reps : $max_value_of_reps");
    }
  }
  update_max_min_val() {
    for (var i = 0; i < Sets.length; i++) {
      if (max_value_of_exersice < Sets[i].max) {
        max_value_of_exersice = Sets[i].max;
      }
      if (max_value_of_reps < Sets[i].reps) {
        max_value_of_reps = Sets[i].reps;
      }
      //
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'Sets': Sets.map((set) => set.toJson()).toList(),
      'max_value_of_exersice': max_value_of_exersice,
      'max_value_of_reps': max_value_of_reps,
      'last_time_sets': last_time_sets,
    };
  }

  factory exercise_info.fromJson(Map<String, dynamic> json) {
    return exercise_info(
      json['name'],
      (json['Sets'] as List)
          .map((setJson) => Sets_ins.fromJson(setJson))
          .toList(),
      json['last_time_sets'],
    );
  }
}

class Weekdays {
  var name;
  var stratergy_name;
  var exercises;
  var workout_time = 0;
  Weekdays(this.name, this.stratergy_name, this.exercises, this.workout_time);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'stratergy_name': stratergy_name,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
      'workout_time': workout_time,
    };
  }

  factory Weekdays.fromJson(Map<String, dynamic> json) {
    return Weekdays(
      json['name'],
      json['stratergy_name'],
      (json['exercises'] as List)
          .map((exerciseJson) => exercise_info.fromJson(exerciseJson))
          .toList(),
      json['workout_time'],
    );
  }
}

class data {
  var total_estimated_time;
  var weekdays;
  var workout_routines;
  data(this.weekdays, this.workout_routines) {
    for (int i = 0; i < weekdays.length; i++) {
      total_estimated_time += weekdays[i].workout_time;
    }
  }
  Map<String, dynamic> make_map() {
    Map<String, dynamic> map = {};
    map['total_estimated_time'] = total_estimated_time;
    map['weekdays'] = weekdays.map((weekday) => weekday.toJson()).toList();
    map['workout_routines'] = workout_routines;
    return map;
  }

  data.fetch_data(Map<String, dynamic>? map) {
    total_estimated_time = map?['total_estimated_time'];
    weekdays = (map?['weekdays'] as List)
        .map((weekdayJson) => Weekdays.fromJson(weekdayJson))
        .toList();
    workout_routines = (map?['workout_routines'] as List).cast<String>();
  }
  String toJsonString() {
    return jsonEncode(make_map());
  }

  static data fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return data.fetch_data(jsonMap);
  }

  @override
  String toString() {
    return 'Data{total_estimated_time: $total_estimated_time, weekdays: $weekdays, workout_routines: $workout_routines}';
  }
}