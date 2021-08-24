class HttpMock {
  Future<void> delayRequest({
    int duration = 3,
    Exception? exceptionObj,
  }) async {
    await Future.delayed(Duration(seconds: duration));
    if (exceptionObj != null) {
      throw exceptionObj;
    }
  }
}
