class PageDto<T> {
  final int total;
  final List<T> data;

  PageDto({
    required this.total,
    required this.data,
  });

  factory PageDto.fromJson(Map<String, dynamic> json) {
    return PageDto(
      total: json['total'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'data': data,
  };
}