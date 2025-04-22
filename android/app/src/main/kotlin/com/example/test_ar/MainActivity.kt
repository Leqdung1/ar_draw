package com.example.test_ar

import LargeNativeAdFactory
import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Handler
import android.os.Looper
import com.example.test_ar.MainActivity.TimeHandler.eventSink
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import java.text.SimpleDateFormat
import java.util.Date

class MainActivity : FlutterActivity() {

    private val eventChannel = "timeHandlerEvent"
    private val batteryEventChannel = "batteryHandlerEvent"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val smallNativeFactory = SmallNativeFactory(layoutInflater)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "smallNativeAd", smallNativeFactory)

        val largeNativeAdFactory = LargeNativeAdFactory(layoutInflater)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "largeNativeAd", largeNativeAdFactory)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(TimeHandler)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, batteryEventChannel).setStreamHandler(BatteryHandler(this))
    }

    override fun detachFromFlutterEngine() {
        super.detachFromFlutterEngine()
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "smallNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "largeNativeAd")
    }

    object TimeHandler : EventChannel.StreamHandler {
        private val handler = Handler(Looper.getMainLooper())
        var eventSink: EventChannel.EventSink? = null

        @SuppressLint("SimpleDateFormat")
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
            val r: Runnable = object : Runnable {
                override fun run() {
                    val time = SimpleDateFormat("HH:mm:ss").format(Date())
                    eventSink?.success(time)
                    handler.postDelayed(this, 1000)
                }
            }
            handler.post(r)
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }
    }

    class BatteryHandler(private val context: Context) : EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null

        private val batteryReceiver = object : BroadcastReceiver() {
            override fun onReceive(ctx: Context?, intent: Intent?) {
                val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
                eventSink?.success("Battery level: $level%")
            }
        }

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
            context.registerReceiver(batteryReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        }

        override fun onCancel(arguments: Any?) {
            context.unregisterReceiver(batteryReceiver)
            eventSink = null
        }
    }
}
