import 'package:flutrace_web/core/error/failures.dart';
import 'package:flutrace_web/core/error/repository_request_handler.dart';
import 'package:flutrace_web/core/helper/type_aliases.dart';
import 'package:flutrace_web/features/projects/data/datasource/project_datasource.dart';
import 'package:flutrace_web/features/projects/domain/entities/project_entity.dart';
import 'package:flutrace_web/features/projects/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl extends ProjectRepository {
  ProjectRepositoryImpl({
    required this.datasource,
  });

  final ProjectDatasource datasource;

  @override
  FutureFailable<List<ProjectEntity>> getProjects() {
    return RepositoryRequestHandler<List<ProjectEntity>>()(
      request: () async {
        final result = await datasource.getProjects();
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<ProjectEntity> getProjectById(String id) {
    return RepositoryRequestHandler<ProjectEntity>()(
      request: () async {
        final result = await datasource.getProjectById(id);
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<ProjectEntity> createProject(String name) {
    return RepositoryRequestHandler<ProjectEntity>()(
      request: () async {
        final result = await datasource.createProject(name);
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<ProjectEntity> updateProjectName(String id, String name) {
    return RepositoryRequestHandler<ProjectEntity>()(
      request: () async {
        final result = await datasource.updateProjectName(id, name);
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<ProjectEntity> addProjectOwner(String projectId, String ownerEmail) {
    return RepositoryRequestHandler<ProjectEntity>()(
      request: () async {
        final result = await datasource.addProjectOwner(projectId, ownerEmail);
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<ProjectEntity> removeProjectOwner(String projectId, String ownerEmail) {
    return RepositoryRequestHandler<ProjectEntity>()(
      request: () async {
        final result = await datasource.removeProjectOwner(projectId, ownerEmail);
        return result;
      },
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<void> deleteProject(String id) {
    return RepositoryRequestHandler<void>()(
      request: () async {
        await datasource.deleteProject(id);
      },
      defaultFailure: LogInFailure(),
    );
  }
}
