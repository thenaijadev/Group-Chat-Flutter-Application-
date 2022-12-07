//Login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//Register Exceptions

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

//Generic exceptions

class GenericAuthException implements Exception {}

//If user is null after registering
class UserNotLoggedInAuthException implements Exception {}
