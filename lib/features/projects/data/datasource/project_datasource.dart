import 'package:dio/dio.dart';
import 'package:flutrace_web/features/projects/data/models/project_model.dart';

abstract class ProjectDatasource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProjectById(String id);
  Future<ProjectModel> createProject(String name);
  Future<ProjectModel> updateProjectName(String id, String name);
  Future<ProjectModel> addProjectOwner(String projectId, String ownerEmail);
  Future<ProjectModel> removeProjectOwner(String projectId, String ownerEmail);
  Future<void> deleteProject(String id);
}

class ProjectDatasourceImpl extends ProjectDatasource {
  ProjectDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<ProjectModel>> getProjects() async {
    final response = await dio.get('projects/');
    if (response.data == null || (response.data as List).isEmpty) {
      return [];
    }
    final data = response.data as List;
    return data.map((json) => ProjectModel.fromJson(json)).toList();
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    final response = await dio.get('projects/$id');
    return ProjectModel.fromJson(response.data);
  }

  @override
  Future<ProjectModel> createProject(String name) async {
    final response = await dio.post(
      'projects/',
      data: {'name': name},
    );
    return ProjectModel.fromJson(response.data);
  }

  @override
  Future<ProjectModel> updateProjectName(String id, String name) async {
    final response = await dio.put(
      'projects/$id',
      data: {'name': name},
    );
    return ProjectModel.fromJson(response.data);
  }

  @override
  Future<ProjectModel> addProjectOwner(String projectId, String ownerEmail) async {
    final response = await dio.put(
      'projects/$projectId/add-user',
      queryParameters: {
        'email': ownerEmail,
      },
    );
    return ProjectModel.fromJson(response.data);
  }

  @override
  Future<ProjectModel> removeProjectOwner(String projectId, String ownerEmail) async {
    final response = await dio.put(
      'projects/$projectId/remove-user',
      queryParameters: {
        'email': ownerEmail,
      },
    );
    return ProjectModel.fromJson(response.data);
  }

  @override
  Future<void> deleteProject(String id) async {
    await dio.delete('projects/$id');
  }
}