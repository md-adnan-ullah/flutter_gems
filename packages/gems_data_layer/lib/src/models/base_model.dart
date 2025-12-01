/// Base Model interface
/// Implement this in your models
abstract class BaseModel {
  Map<String, dynamic> toJson();
  
  factory BaseModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson must be implemented');
  }
}

