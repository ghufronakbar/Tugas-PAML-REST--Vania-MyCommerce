class ResponseHelper {
  static Map<String, dynamic> success(dynamic data,
      [String message = 'Data berhasil di proses']) {
    return {'status': 200, 'message': message, 'data': data};
  }

  static Map<String, dynamic> error([String message = 'Terjadi kesalahan']) {
    return {'status': 500, 'message': message, 'data': null};
  }

  static Map<String, dynamic> notFound(
      [String message = 'Data tidak di temukan']) {
    return {'status': 404, 'message': message, 'data': null};
  }

  static Map<String, dynamic> invalid([String message = 'Data tidak valid']) {
    return {'status': 400, 'message': message, 'data': null};
  }
}
