import Flutter
import UIKit

public class SwiftMemoryPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "memory_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftMemoryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getMemoryInfo":
      result("iOS memory")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
