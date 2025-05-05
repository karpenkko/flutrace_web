part of 'project_cubit.dart';

abstract class ProjectState extends Equatable {
  final ProjectStateData stateData;

  const ProjectState({required this.stateData});

  @override
  List<Object?> get props => [stateData];
}

class ProjectInitial extends ProjectState {
  const ProjectInitial({required super.stateData});
}

class ProjectLoading extends ProjectState {
  const ProjectLoading({required super.stateData});
}

class ProjectLoaded extends ProjectState {
  const ProjectLoaded({required super.stateData});
}

class ProjectCreated extends ProjectState {
  const ProjectCreated({required super.stateData});
}

class ProjectDeleted extends ProjectState {
  const ProjectDeleted({required super.stateData});
}

class ProjectError extends ProjectState {
  final String message;

  const ProjectError({required this.message, required super.stateData});

  @override
  List<Object?> get props => [message, ...super.props];
}
