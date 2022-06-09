class ApiResponse{
  final bool status;
  final String message;
  ApiResponse(this.status,this.message);

  ApiResponse.map(dynamic json)
      :status=json['status'],
        message=json['message'] ?? json['accessToken'];

}


class RegistrationResponse{
  final bool status;
  final String message;
  RegistrationResponse(this.status,this.message);

  RegistrationResponse.map(dynamic json)
        :status=json['status'],
        message=json['token'];

}