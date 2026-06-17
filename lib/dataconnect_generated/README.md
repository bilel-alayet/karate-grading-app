# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ListAllBelts
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listAllBelts().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListAllBeltsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listAllBelts();
ListAllBeltsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listAllBelts().ref();
ref.execute();

ref.subscribe(...);
```


### GetMyChildren
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getMyChildren().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyChildrenData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMyChildren();
GetMyChildrenData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getMyChildren().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### RegisterChildForExam
#### Required Arguments
```dart
String childId = ...;
String examId = ...;
String beltId = ...;
ExampleConnector.instance.registerChildForExam(
  childId: childId,
  examId: examId,
  beltId: beltId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RegisterChildForExamData, RegisterChildForExamVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.registerChildForExam(
  childId: childId,
  examId: examId,
  beltId: beltId,
);
RegisterChildForExamData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String childId = ...;
String examId = ...;
String beltId = ...;

final ref = ExampleConnector.instance.registerChildForExam(
  childId: childId,
  examId: examId,
  beltId: beltId,
).ref();
ref.execute();
```


### RecordExamResult
#### Required Arguments
```dart
String examRegistrationId = ...;
String childId = ...;
String beltId = ...;
bool passed = ...;
ExampleConnector.instance.recordExamResult(
  examRegistrationId: examRegistrationId,
  childId: childId,
  beltId: beltId,
  passed: passed,
).execute();
```

#### Optional Arguments
We return a builder for each query. For RecordExamResult, we created `RecordExamResultBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class RecordExamResultVariablesBuilder {
  ...
   RecordExamResultVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.recordExamResult(
  examRegistrationId: examRegistrationId,
  childId: childId,
  beltId: beltId,
  passed: passed,
)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<RecordExamResultData, RecordExamResultVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.recordExamResult(
  examRegistrationId: examRegistrationId,
  childId: childId,
  beltId: beltId,
  passed: passed,
);
RecordExamResultData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String examRegistrationId = ...;
String childId = ...;
String beltId = ...;
bool passed = ...;

final ref = ExampleConnector.instance.recordExamResult(
  examRegistrationId: examRegistrationId,
  childId: childId,
  beltId: beltId,
  passed: passed,
).ref();
ref.execute();
```

