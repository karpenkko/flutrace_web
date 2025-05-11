import 'package:equatable/equatable.dart';
import 'package:flutrace_web/features/projects/domain/entities/project_entity.dart';

enum ProjectTab { dashboard, logs, analytics, settings }

class ProjectStateData extends Equatable {
  final List<ProjectEntity>? projects;
  final ProjectEntity? selectedProject;
  final ProjectTab selectedTab;
  final String? addingProjectOwnerError;

  const ProjectStateData({
    this.projects,
    this.selectedProject,
    required this.selectedTab,
    this.addingProjectOwnerError,
  });

  static ProjectStateData init() {
    return const ProjectStateData(
      projects: [],
      selectedProject: null,
      selectedTab: ProjectTab.dashboard,
      addingProjectOwnerError: null,
    );
  }

  ProjectStateData copyWith({
    List<ProjectEntity>? projects,
    ProjectEntity? selectedProject,
    ProjectTab? selectedTab,
    String? addingProjectOwnerError,
  }) {
    return ProjectStateData(
      projects: projects ?? this.projects,
      selectedProject: selectedProject ?? this.selectedProject,
      selectedTab: selectedTab ?? this.selectedTab,
      addingProjectOwnerError: addingProjectOwnerError ?? this.addingProjectOwnerError,
    );
  }

  @override
  List<Object?> get props => [projects, selectedProject, selectedTab, addingProjectOwnerError];
}
