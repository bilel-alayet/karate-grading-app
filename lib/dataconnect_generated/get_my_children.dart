part of 'generated.dart';

class GetMyChildrenVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyChildrenVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyChildrenData> dataDeserializer = (dynamic json)  => GetMyChildrenData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyChildrenData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetMyChildrenData, void> ref() {
    
    return _dataConnect.query("GetMyChildren", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyChildrenUsers {
  final String displayName;
  final List<GetMyChildrenUsersChildrenOnParent> children_on_parent;
  GetMyChildrenUsers.fromJson(dynamic json):
  
  displayName = nativeFromJson<String>(json['displayName']),
  children_on_parent = (json['children_on_parent'] as List<dynamic>)
        .map((e) => GetMyChildrenUsersChildrenOnParent.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyChildrenUsers otherTyped = other as GetMyChildrenUsers;
    return displayName == otherTyped.displayName && 
    children_on_parent == otherTyped.children_on_parent;
    
  }
  @override
  int get hashCode => Object.hashAll([displayName.hashCode, children_on_parent.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['displayName'] = nativeToJson<String>(displayName);
    json['children_on_parent'] = children_on_parent.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyChildrenUsers({
    required this.displayName,
    required this.children_on_parent,
  });
}

@immutable
class GetMyChildrenUsersChildrenOnParent {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final GetMyChildrenUsersChildrenOnParentCurrentBelt currentBelt;
  GetMyChildrenUsersChildrenOnParent.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  firstName = nativeFromJson<String>(json['firstName']),
  lastName = nativeFromJson<String>(json['lastName']),
  dateOfBirth = nativeFromJson<DateTime>(json['dateOfBirth']),
  currentBelt = GetMyChildrenUsersChildrenOnParentCurrentBelt.fromJson(json['currentBelt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyChildrenUsersChildrenOnParent otherTyped = other as GetMyChildrenUsersChildrenOnParent;
    return id == otherTyped.id && 
    firstName == otherTyped.firstName && 
    lastName == otherTyped.lastName && 
    dateOfBirth == otherTyped.dateOfBirth && 
    currentBelt == otherTyped.currentBelt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, firstName.hashCode, lastName.hashCode, dateOfBirth.hashCode, currentBelt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['firstName'] = nativeToJson<String>(firstName);
    json['lastName'] = nativeToJson<String>(lastName);
    json['dateOfBirth'] = nativeToJson<DateTime>(dateOfBirth);
    json['currentBelt'] = currentBelt.toJson();
    return json;
  }

  GetMyChildrenUsersChildrenOnParent({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.currentBelt,
  });
}

@immutable
class GetMyChildrenUsersChildrenOnParentCurrentBelt {
  final String name;
  final int order;
  GetMyChildrenUsersChildrenOnParentCurrentBelt.fromJson(dynamic json):
  
  name = nativeFromJson<String>(json['name']),
  order = nativeFromJson<int>(json['order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyChildrenUsersChildrenOnParentCurrentBelt otherTyped = other as GetMyChildrenUsersChildrenOnParentCurrentBelt;
    return name == otherTyped.name && 
    order == otherTyped.order;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['order'] = nativeToJson<int>(order);
    return json;
  }

  GetMyChildrenUsersChildrenOnParentCurrentBelt({
    required this.name,
    required this.order,
  });
}

@immutable
class GetMyChildrenData {
  final List<GetMyChildrenUsers> users;
  GetMyChildrenData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => GetMyChildrenUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyChildrenData otherTyped = other as GetMyChildrenData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyChildrenData({
    required this.users,
  });
}

