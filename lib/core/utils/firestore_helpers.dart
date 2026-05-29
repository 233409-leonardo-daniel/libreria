class FirestoreHelpers {
  /// Converts a standard Dart Map to Firestore REST API 'fields' format.
  static Map<String, dynamic> buildFields(Map<String, dynamic> data) {
    final Map<String, dynamic> fields = {};
    
    data.forEach((key, value) {
      if (value is String) {
        fields[key] = {'stringValue': value};
      } else if (value is int) {
        fields[key] = {'integerValue': value.toString()};
      } else if (value is double) {
        fields[key] = {'doubleValue': value};
      } else if (value is bool) {
        fields[key] = {'booleanValue': value};
      } else if (value == null) {
        fields[key] = {'nullValue': null};
      } else if (value is Map<String, dynamic>) {
        fields[key] = {'mapValue': {'fields': buildFields(value)}};
      } else if (value is List) {
        // Simplified list handling for primitive types
        final listValues = value.map((e) {
          if (e is String) return {'stringValue': e};
          if (e is int) return {'integerValue': e.toString()};
          if (e is bool) return {'booleanValue': e};
          return {};
        }).toList();
        fields[key] = {
          'arrayValue': {'values': listValues}
        };
      } else if (value is DateTime) {
        fields[key] = {'timestampValue': value.toUtc().toIso8601String()};
      }
    });

    return fields;
  }

  /// Parses a Firestore REST API 'fields' object into a standard Dart Map.
  static Map<String, dynamic> parseFields(Map<String, dynamic> fields) {
    final Map<String, dynamic> parsedData = {};

    fields.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        if (value.containsKey('stringValue')) {
          parsedData[key] = value['stringValue'];
        } else if (value.containsKey('integerValue')) {
          parsedData[key] = int.tryParse(value['integerValue'].toString()) ?? 0;
        } else if (value.containsKey('doubleValue')) {
          parsedData[key] = (value['doubleValue'] as num).toDouble();
        } else if (value.containsKey('booleanValue')) {
          parsedData[key] = value['booleanValue'] == true;
        } else if (value.containsKey('nullValue')) {
          parsedData[key] = null;
        } else if (value.containsKey('mapValue')) {
          parsedData[key] = parseFields(value['mapValue']['fields'] ?? {});
        } else if (value.containsKey('arrayValue')) {
          final values = value['arrayValue']['values'] as List? ?? [];
          parsedData[key] = values.map((e) {
             if (e is Map) {
               if (e.containsKey('stringValue')) return e['stringValue'];
               if (e.containsKey('integerValue')) return int.tryParse(e['integerValue'].toString());
               if (e.containsKey('booleanValue')) return e['booleanValue'];
             }
             return null;
          }).toList();
        } else if (value.containsKey('timestampValue')) {
          parsedData[key] = DateTime.tryParse(value['timestampValue'].toString());
        }
      }
    });

    return parsedData;
  }

  /// Extracts the document ID from a full Firestore document name path.
  static String extractIdFromPath(String name) {
    final parts = name.split('/');
    return parts.isNotEmpty ? parts.last : '';
  }
}
