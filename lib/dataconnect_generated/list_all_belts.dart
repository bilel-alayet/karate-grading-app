part of 'generated.dart';

class ListAllBeltsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListAllBeltsVariablesBuilder(this._dataConnect, );
  Deserializer<ListAllBeltsData> dataDeserializer = (dynamic json)  => ListAllBeltsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListAllBeltsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListAllBeltsData, void> ref() {
    
    return _dataConnect.query("ListAllBelts", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListAllBeltsBelts {
  final String id;
  final String name;
  final int order;
  final String? requirements;
  ListAllBeltsBelts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  order = nativeFromJson<int>(json['order']),
  requirements = json['requirements'] == null ? null : nativeFromJson<String>(json['requirements']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAllBeltsBelts otherTyped = other as ListAllBeltsBelts;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    order == otherTyped.order && 
    requirements == otherTyped.requirements;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, order.hashCode, requirements.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['order'] = nativeToJson<int>(order);
    if (requirements != null) {
      json['requirements'] = nativeToJson<String?>(requirements);
    }
    return json;
  }

  ListAllBeltsBelts({
    required this.id,
    required this.name,
    required this.order,
    this.requirements,
  });
}

@immutable
class ListAllBeltsData {
  final List<ListAllBeltsBelts> belts;
  ListAllBeltsData.fromJson(dynamic json):
  
  belts = (json['belts'] as List<dynamic>)
        .map((e) => ListAllBeltsBelts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAllBeltsData otherTyped = other as ListAllBeltsData;
    return belts == otherTyped.belts;
    
  }
  @override
  int get hashCode => belts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['belts'] = belts.map((e) => e.toJson()).toList();
    return json;
  }

  ListAllBeltsData({
    required this.belts,
  });
}

