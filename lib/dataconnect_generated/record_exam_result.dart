part of 'generated.dart';

class RecordExamResultVariablesBuilder {
  String examRegistrationId;
  String childId;
  String beltId;
  bool passed;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  RecordExamResultVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  RecordExamResultVariablesBuilder(this._dataConnect, {required  this.examRegistrationId,required  this.childId,required  this.beltId,required  this.passed,});
  Deserializer<RecordExamResultData> dataDeserializer = (dynamic json)  => RecordExamResultData.fromJson(jsonDecode(json));
  Serializer<RecordExamResultVariables> varsSerializer = (RecordExamResultVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RecordExamResultData, RecordExamResultVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RecordExamResultData, RecordExamResultVariables> ref() {
    RecordExamResultVariables vars= RecordExamResultVariables(examRegistrationId: examRegistrationId,childId: childId,beltId: beltId,passed: passed,notes: _notes,);
    return _dataConnect.mutation("RecordExamResult", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RecordExamResultExamResultInsert {
  final String id;
  RecordExamResultExamResultInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RecordExamResultExamResultInsert otherTyped = other as RecordExamResultExamResultInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RecordExamResultExamResultInsert({
    required this.id,
  });
}

@immutable
class RecordExamResultData {
  final RecordExamResultExamResultInsert examResult_insert;
  RecordExamResultData.fromJson(dynamic json):
  
  examResult_insert = RecordExamResultExamResultInsert.fromJson(json['examResult_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RecordExamResultData otherTyped = other as RecordExamResultData;
    return examResult_insert == otherTyped.examResult_insert;
    
  }
  @override
  int get hashCode => examResult_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['examResult_insert'] = examResult_insert.toJson();
    return json;
  }

  RecordExamResultData({
    required this.examResult_insert,
  });
}

@immutable
class RecordExamResultVariables {
  final String examRegistrationId;
  final String childId;
  final String beltId;
  final bool passed;
  late final Optional<String>notes;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RecordExamResultVariables.fromJson(Map<String, dynamic> json):
  
  examRegistrationId = nativeFromJson<String>(json['examRegistrationId']),
  childId = nativeFromJson<String>(json['childId']),
  beltId = nativeFromJson<String>(json['beltId']),
  passed = nativeFromJson<bool>(json['passed']) {
  
  
  
  
  
  
    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null ? null : nativeFromJson<String>(json['notes']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RecordExamResultVariables otherTyped = other as RecordExamResultVariables;
    return examRegistrationId == otherTyped.examRegistrationId && 
    childId == otherTyped.childId && 
    beltId == otherTyped.beltId && 
    passed == otherTyped.passed && 
    notes == otherTyped.notes;
    
  }
  @override
  int get hashCode => Object.hashAll([examRegistrationId.hashCode, childId.hashCode, beltId.hashCode, passed.hashCode, notes.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['examRegistrationId'] = nativeToJson<String>(examRegistrationId);
    json['childId'] = nativeToJson<String>(childId);
    json['beltId'] = nativeToJson<String>(beltId);
    json['passed'] = nativeToJson<bool>(passed);
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    return json;
  }

  RecordExamResultVariables({
    required this.examRegistrationId,
    required this.childId,
    required this.beltId,
    required this.passed,
    required this.notes,
  });
}

