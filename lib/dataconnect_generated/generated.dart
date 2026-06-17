library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'list_all_belts.dart';

part 'register_child_for_exam.dart';

part 'get_my_children.dart';

part 'record_exam_result.dart';







class ExampleConnector {
  
  
  ListAllBeltsVariablesBuilder listAllBelts () {
    return ListAllBeltsVariablesBuilder(dataConnect, );
  }
  
  
  RegisterChildForExamVariablesBuilder registerChildForExam ({required String childId, required String examId, required String beltId, }) {
    return RegisterChildForExamVariablesBuilder(dataConnect, childId: childId,examId: examId,beltId: beltId,);
  }
  
  
  GetMyChildrenVariablesBuilder getMyChildren () {
    return GetMyChildrenVariablesBuilder(dataConnect, );
  }
  
  
  RecordExamResultVariablesBuilder recordExamResult ({required String examRegistrationId, required String childId, required String beltId, required bool passed, }) {
    return RecordExamResultVariablesBuilder(dataConnect, examRegistrationId: examRegistrationId,childId: childId,beltId: beltId,passed: passed,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'appbilelreal',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:0),
      storage: CacheStorage.persistent,
    );
    
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
