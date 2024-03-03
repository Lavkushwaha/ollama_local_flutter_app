// To parse this JSON data, do
//
//     final chatResponseEntity = chatResponseEntityFromJson(jsonString);

import 'dart:convert';

ChatResponseEntity chatResponseEntityFromJson(String str) => ChatResponseEntity.fromJson(json.decode(str));

String chatResponseEntityToJson(ChatResponseEntity data) => json.encode(data.toJson());

class ChatResponseEntity {
  final String? model;
  final DateTime? createdAt;
  final String response;
  final bool? done;
  final List<int>? context;
  final int? totalDuration;
  final int? loadDuration;
  final int? promptEvalCount;
  final int? promptEvalDuration;
  final int? evalCount;
  final int? evalDuration;

  ChatResponseEntity({
    this.model,
    this.createdAt,
    required this.response,
    this.done,
    this.context,
    this.totalDuration,
    this.loadDuration,
    this.promptEvalCount,
    this.promptEvalDuration,
    this.evalCount,
    this.evalDuration,
  });

  factory ChatResponseEntity.fromJson(Map<String, dynamic> json) => ChatResponseEntity(
        model: json["model"],
        createdAt: DateTime.parse(json["created_at"]),
        response: json["response"],
        done: json["done"],
        context: json["context"] == null ? [] : List<int>.from(json["context"].map((x) => x)),
        totalDuration: json["total_duration"] ?? 0,
        loadDuration: json["load_duration"] ?? 0,
        promptEvalCount: json["prompt_eval_count"] ?? 0,
        promptEvalDuration: json["prompt_eval_duration"] ?? 0,
        evalCount: json["eval_count"] ?? 0,
        evalDuration: json["eval_duration"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "created_at": createdAt?.toIso8601String(),
        "response": response,
        "done": done,
        "context": List<dynamic>.from(context!.map((x) => x)),
        "total_duration": totalDuration,
        "load_duration": loadDuration,
        "prompt_eval_count": promptEvalCount,
        "prompt_eval_duration": promptEvalDuration,
        "eval_count": evalCount,
        "eval_duration": evalDuration,
      };
}
