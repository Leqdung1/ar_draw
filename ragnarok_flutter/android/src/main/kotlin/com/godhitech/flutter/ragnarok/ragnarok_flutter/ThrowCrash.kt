package com.godhitech.flutter.ragnarok.ragnarok_flutter

class ThrowCrash(var message:String){
    init {
        throw RuntimeException(message)
    }
}