import 'package:equatable/equatable.dart';
import 'package:flutrace_web/features/projects/domain/entities/project_entity.dart';
import 'package:flutrace_web/features/projects/domain/repositories/project_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'project_state_data.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final ProjectRepository _repository;

  ProjectCubit({required ProjectRepository repository})
      : _repository = repository,
        super(
          ProjectInitial(
            stateData: ProjectStateData.init(),
          ),
        );

  ProjectStateData get _data => state.stateData;

  Future<void> fetchProjects() async {
    emit(ProjectLoading(stateData: _data));

    final response = await _repository.getProjects();
    response.fold(
      (failure) {
        emit(ProjectError(
          message: failure.errorMessage,
          stateData: _data,
        ));
      },
      (projects) {
        emit(ProjectLoaded(
          stateData: _data.copyWith(projects: projects),
        ));
      },
    );
  }

  Future<void> createProject(String name) async {
    emit(ProjectLoading(stateData: _data));

    final response = await _repository.createProject(name);
    response.fold(
      (failure) {
        emit(ProjectError(
          message: failure.errorMessage,
          stateData: _data,
        ));
      },
      (project) {
        final updatedProjects = [...?_data.projects];
        if (!updatedProjects.any((p) => p.id == project.id)) {
          updatedProjects.add(project);
        }
        emit(ProjectCreated(
          stateData: _data.copyWith(
            projects: updatedProjects,
            selectedProject: project,
          ),
        ));
      },
    );
  }

  void selectProject(ProjectEntity project) {
    emit(ProjectLoaded(
      stateData: _data.copyWith(selectedProject: project),
    ));
  }

  Future<void> loadProjectById(String id) async {
    emit(ProjectLoading(stateData: _data));

    final response = await _repository.getProjectById(id);
    response.fold(
      (failure) {
        emit(ProjectError(
          message: failure.errorMessage,
          stateData: _data,
        ));
      },
      (project) {
        final updatedProjects = [...?_data.projects];
        if (!updatedProjects.any((p) => p.id == project.id)) {
          updatedProjects.add(project);
        }
        emit(ProjectLoaded(
          stateData: _data.copyWith(
            projects: updatedProjects,
            selectedProject: project,
          ),
        ));
      },
    );
  }

  void changeTab(ProjectTab tab) {
    emit(ProjectLoaded(
      stateData: _data.copyWith(selectedTab: tab),
    ));
  }

  Future<void> updateProjectName(String name) async {
    emit(ProjectLoading(stateData: _data));

    final response =
        await _repository.updateProjectName(_data.selectedProject!.id, name);
    response.fold(
      (failure) {
        emit(ProjectError(
          message: failure.errorMessage,
          stateData: _data,
        ));
      },
      (project) {
        final List<ProjectEntity> updatedProjects = [..._data.projects ?? []];
        final index = updatedProjects.indexWhere((p) => p.id == project.id);

        if (index != -1) {
          updatedProjects[index] = project;
        }
        emit(ProjectLoaded(
          stateData: _data.copyWith(
            projects: updatedProjects,
            selectedProject: project,
          ),
        ));
      },
    );
  }

  Future<void> addProjectOwner(String ownerEmail) async {
    emit(ProjectLoading(stateData: _data));

    final response = await _repository.addProjectOwner(
      _data.selectedProject!.id,
      ownerEmail,
    );
    response.fold(
      (failure) {
        emit(ProjectError(
          message: failure.errorMessage,
          stateData: _data,
        ));
      },
      (project) {
        final List<ProjectEntity> updatedProjects = [..._data.projects ?? []];
        final index = updatedProjects.indexWhere((p) => p.id == project.id);
        if (index != -1) {
          updatedProjects[index] = project;
        }
        emit(ProjectLoaded(
          stateData: _data.copyWith(
            projects: updatedProjects,
            selectedProject: project,
          ),
        ));
      },
    );
  }

  Future<void> removeProjectOwner(String ownerEmail) async {
    emit(ProjectLoading(stateData: _data));

    final response = await _repository.removeProjectOwner(
      _data.selectedProject!.id,
      ownerEmail,
    );
    response.fold(
          (failure) {
        emit(ProjectError(
          message: failure.errorMessage,
          stateData: _data,
        ));
      },
          (project) {
        final List<ProjectEntity> updatedProjects = [..._data.projects ?? []];
        final index = updatedProjects.indexWhere((p) => p.id == project.id);
        if (index != -1) {
          updatedProjects[index] = project;
        }
        emit(ProjectLoaded(
          stateData: _data.copyWith(
            projects: updatedProjects,
            selectedProject: project,
          ),
        ));
      },
    );
  }

  Future<void> deleteProject() async {
    emit(ProjectLoading(stateData: _data));

    final response = await _repository.deleteProject(_data.selectedProject!.id);
    response.fold(
      (failure) {
        emit(ProjectError(
          message: failure.errorMessage,
          stateData: _data,
        ));
      },
      (_) {
        final updatedProjects = [...?_data.projects];
        updatedProjects.removeWhere((p) => p.id == _data.selectedProject!.id);
        emit(ProjectDeleted(
          stateData: _data.copyWith(
            projects: updatedProjects,
            selectedProject: null,
          ),
        ));
      },
    );
  }
}
