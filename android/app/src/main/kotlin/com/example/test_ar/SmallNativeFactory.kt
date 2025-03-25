package com.example.test_ar

import android.view.LayoutInflater
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

internal class SmallNativeFactory(layoutInflater: LayoutInflater): NativeAdFactory {
    private var layoutInflater: LayoutInflater

    init {
        this.layoutInflater = layoutInflater
    }

    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val adView: NativeAdView = layoutInflater.inflate(R.layout.small_native_layout, null) as NativeAdView

        adView.headlineView = adView.findViewById(R.id.small_native_layout_header_id)
        adView.bodyView = adView.findViewById(R.id.small_native_layout_body_id)
        adView.iconView = adView.findViewById(R.id.small_native_layout_image_id)
        adView.callToActionView = adView.findViewById(R.id.small_native_layout_cta_id)

        if(nativeAd.headline == null){
            adView.headlineView?.visibility = android.view.View.GONE
        }else{
            (adView.headlineView as TextView).text = nativeAd.headline
            adView.headlineView?.visibility = android.view.View.VISIBLE
        }

        if(nativeAd.body == null){
            adView.bodyView?.visibility = android.view.View.GONE
        }else{
            (adView.bodyView as TextView).text = nativeAd.body
            adView.bodyView?.visibility = android.view.View.VISIBLE
        }

        if(nativeAd.icon == null){
            adView.iconView?.visibility = android.view.View.GONE
        }else{
            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon?.drawable)
            adView.iconView?.visibility = android.view.View.VISIBLE
        }

        if(nativeAd.callToAction == null){
            adView.callToActionView?.visibility = android.view.View.GONE
        }else{
            (adView.callToActionView as TextView).text = nativeAd.callToAction
            adView.callToActionView?.visibility = android.view.View.VISIBLE

        }

        adView.setNativeAd(nativeAd)

        return adView
    }
}