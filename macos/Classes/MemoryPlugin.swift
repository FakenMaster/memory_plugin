import Cocoa
import FlutterMacOS

public class MemoryPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "memory_plugin", binaryMessenger: registrar.messenger)
    let instance = MemoryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "getMemoryInfo":
      result(report_memory())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func report_memory() -> String{
    var taskInfo = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
        }
    }

    if kerr == KERN_SUCCESS {
        return "Memory used in bytes: \(bytesToHuman(size: Double(taskInfo.resident_size)))"
    }
    else {
        return "Error with task_info(): " +
            (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error")
    }
  }

  func floatForm(d: Double) -> String{
    return String(format: "%.2f", d);
  }

  func bytesToHuman(size: Double)-> String {
      let Kb : Double = 1024;
      let Mb = Kb * 1024;
      let Gb = Mb * 1024;
      let Tb = Gb * 1024;
      let Pb = Tb * 1024;
      let Eb = Pb * 1024;

      if (size < Kb){
        return floatForm(d: size) + " byte";
      }

      if (size >= Kb && size < Mb){
         return floatForm(d: size / Kb) + " KB";
      }
      if (size >= Mb && size < Gb){
         return floatForm(d: size / Mb) + " MB";
      }
      if (size >= Gb && size < Tb){
         return floatForm(d: size / Gb) + " GB";
      }
      if (size >= Tb && size < Pb){ 
        return floatForm(d: size / Tb) + " TB";
      }
      if (size >= Pb && size < Eb){
         return floatForm(d: size / Pb) + " Pb";
      }
      if (size >= Eb){ 
        return floatForm(d: size / Eb) + " Eb";
      }

      return "0";
  }
}
