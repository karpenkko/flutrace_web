import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/projects/domain/entities/project_entity.dart';

abstract class ProjectRepository {
  FutureFailable<List<ProjectEntity>> getProjects();
  FutureFailable<ProjectEntity> getProjectById(String id);
  FutureFailable<ProjectEntity> createProject(String name);
  FutureFailable<ProjectEntity> updateProjectName(String id, String name);
  FutureFailable<ProjectEntity> addProjectOwner(String projectId, String ownerEmail);
  FutureFailable<ProjectEntity> removeProjectOwner(String projectId, String ownerEmail);
  FutureFailable<void> deleteProject(String id);
}
