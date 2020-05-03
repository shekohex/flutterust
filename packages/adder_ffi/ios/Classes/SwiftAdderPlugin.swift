import Flutter
import UIKit

public class SwiftAdderPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // Noop
    result(nil)
  }

  public static func dummyMethodToEnforceBundling() {
    add(40, 2)
  }
}
