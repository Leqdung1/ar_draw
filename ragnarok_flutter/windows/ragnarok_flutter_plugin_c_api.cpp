#include "include/ragnarok_flutter/ragnarok_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "ragnarok_flutter_plugin.h"

void RagnarokFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ragnarok_flutter::RagnarokFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
