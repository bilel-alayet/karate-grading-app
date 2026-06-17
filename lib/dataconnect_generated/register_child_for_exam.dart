part of 'generated.dart';

class RegisterChildForExamVariablesBuilder {
  String childId;
  String examId;
  String beltId;

  final FirebaseDataConnect _dataConnect;
  RegisterChildForExamVariablesBuilder(this._dataConnect, {required  this.childId,required  this.examId,required  this.beltId,});
  Deserializer<RegisterChildForExamData> dataDeserializer = (dynamic json)  => RegisterChildForExamData.fromJson(jsonDecode(json));
  Serializer<RegisterChildForExamVariables> varsSerializer = (RegisterChildForExamVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RegisterChildForExamData, RegisterChildForExamVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RegisterChildForExamData, RegisterChildForExamVariables> ref() {
    RegisterChildForExamVariables vars= RegisterChildForExamVariables(childId: childId,examId: examId,beltId: beltId,);
    return _dataConnect.mutation("RegisterChildForExam", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RegisterChildForExamExamRegistrationInsert {
  final String id;
  RegisterChildForExamExamRegistrationInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterChildForExamExamRegistrationInsert otherTyped = other as RegisterChildForExamExamRegistrationInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterChildForExamExamRegistrationInsert({
    required this.id,
  });
}

@immutable
class RegisterChildForExamData {
  final RegisterChildForExamExamRegistrationInsert examRegistration_insert;
  RegisterChildForExamData.fromJson(dynamic json):
  
  examRegistration_insert = RegisterChildForExamExamRegistrationInsert.fromJson(json['examRegistration_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterChildForExamData otherTyped = other as RegisterChildForExamData;
    return examRegistration_insert == otherTyped.examRegistration_insert;
    
  }
  @override
  int get hashCode => examRegistration_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['examRegistration_insert'] = examRegistration_insert.toJson();
    return json;
  }

  RegisterChildForExamData({
    required this.examRegistration_insert,
  });
}

@immutable
class RegisterChildForExamVariables {
  final String childId;
  final String examId;
  final String beltId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RegisterChildForExamVariables.fromJson(Map<String, dynamic> json):
  
  childId = nativeFromJson<String>(json['childId']),
  examId = nativeFromJson<String>(json['examId']),
  beltId = nativeFromJson<String>(json['beltId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterChildForExamVariables otherTyped = other as RegisterChildForExamVariables;
    return childId == otherTyped.childId && 
    examId == otherTyped.examId && 
    beltId == otherTyped.beltId;
    
  }
  @override
  int get hashCode => Object.hashAll([childId.hashCode, examId.hashCode, beltId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['childId'] = nativeToJson<String>(childId);
    json['examId'] = nativeToJson<String>(examId);
    json['beltId'] = nativeToJson<String>(beltId);
    return json;
  }

  RegisterChildForExamVariables({
    required this.childId,
    required this.examId,
    required this.beltId,
  });
}

