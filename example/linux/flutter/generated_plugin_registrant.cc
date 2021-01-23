//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <memory_plugin/memory_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) memory_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MemoryPlugin");
  memory_plugin_register_with_registrar(memory_plugin_registrar);
}
