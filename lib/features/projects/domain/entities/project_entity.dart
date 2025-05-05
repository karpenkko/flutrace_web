import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable{
  final String id;
  final String name;
  final List<String> users;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.users,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        users,
      ];
}
