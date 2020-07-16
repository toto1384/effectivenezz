package com.effectivenezz.effectivenezz


import androidx.annotation.NonNull
import drift.com.drift.Drift
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.TransparencyMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.native/helper"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "showConversationActivity") {
                Drift.showConversationActivity(this)
                result.success("")
            }else if(call.method == "showCreateConversationActivity") {
                Drift.showCreateConversationActivity(this)
                result.success("")
            }else if(call.method =="setupDrift"){
                Drift.registerUser(call.argument<String>("id").toString(), call.argument<String>("email").toString())
                Drift.showAutomatedMessages(true)
            }
        }
    }


override fun getTransparencyMode(): TransparencyMode {
        return TransparencyMode.transparent
    }
}
