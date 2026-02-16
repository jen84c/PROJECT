import '../models/project.dart';
import 'api_client.dart';

class ProjectService {
  final ApiClient _apiClient;

  ProjectService(this._apiClient);

  Future<List<Project>> getProjects({bool? archived}) async {
    final queryParams = <String, String>{};
    if (archived != null) {
      queryParams['archived'] = archived.toString();
    }

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    final response = await _apiClient.get(
      '/projects${queryString.isNotEmpty ? '?$queryString' : ''}',
    );

    return (response['projects'] as List)
        .map((json) => Project.fromJson(json))
        .toList();
  }

  Future<Project> createProject({
    required String name,
    String? description,
    String? color,
    String? icon,
  }) async {
    final response = await _apiClient.post('/projects', {
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
    });

    return Project.fromJson(response['project']);
  }

  Future<Project> updateProject({
    required String id,
    String? name,
    String? description,
    String? color,
    String? icon,
    bool? archived,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (color != null) data['color'] = color;
    if (icon != null) data['icon'] = icon;
    if (archived != null) data['archived'] = archived;

    final response = await _apiClient.patch('/projects/$id', data);
    return Project.fromJson(response['project']);
  }

  Future<void> deleteProject(String id) async {
    await _apiClient.delete('/projects/$id');
  }
}
