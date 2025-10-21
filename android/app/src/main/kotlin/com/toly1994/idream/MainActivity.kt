package com.toly1994.idream

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine!!)
    }

    override fun getCachedEngineId(): String? {
        return super.getCachedEngineId()
    }
}
