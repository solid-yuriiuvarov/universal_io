// Copyright 2020 terrier989@gmail.com.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library universal_io.browser_driver;

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:meta/meta.dart';

import 'package:universal_io/driver.dart';
import 'package:universal_io/driver_base.dart';
import 'package:universal_io/prefer_universal/io.dart';
import 'dart:typed_data';

part 'browser/http_client.dart';
part 'browser/http_client_exception.dart';
part 'browser/http_client_request.dart';
part 'browser/http_client_response.dart';

/// Determines the default IODriver:
///   * _BrowserIODriver_ in browser (when 'dart:html' is available).
///   * _BaseIODriver_ in Javascript targets such as Node.JS.
///   * Null otherwise (VM, Flutter).
final IODriver defaultIODriver = IODriver(
  parent: null,
  httpOverrides: _BrowserHttpOverrides(),
  platformOverrides: _platformOverridesFromEnvironment(),
  networkInterfaceOverrides: NetworkInterfaceOverrides(),
);

String _operatingSystemFromUserAgent(String customUserAgent) {
  print('customUserAgent: $customUserAgent');
  final userAgent = html.window.navigator.userAgent;
  print('userAgent: $userAgent');
  if (userAgent.contains('Mac OS X')) {
    return 'macos';
  }
  if (userAgent.contains('CrOS')) {
    return 'linux';
  }
  if (userAgent.contains('Android')) {
    return 'android';
  }
  if (userAgent.contains('iPhone')) {
    return 'ios';
  }
  return 'windows';
}

PlatformOverrides _platformOverridesFromEnvironment() {
  // Locale
  var locale = 'en';
  final languages = html.window.navigator.languages;
  if (languages.isNotEmpty) {
    locale = languages.first;
  }

  // Operating system
  final userAgent = html.window.navigator.userAgent;
  final operatingSystem = _operatingSystemFromUserAgent(userAgent);

  return PlatformOverrides(
    numberOfProcessors: html.window.navigator.hardwareConcurrency ?? 1,
    localeName: locale,
    operatingSystem: operatingSystem,
  );
}

class _BrowserHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return _BrowserHttpClient();
  }
}
