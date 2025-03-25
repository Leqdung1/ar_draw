import android.view.LayoutInflater
import android.widget.ImageView
import android.widget.TextView
import com.example.test_ar.R
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

internal class LargeNativeAdFactory(layoutInflater: LayoutInflater) : NativeAdFactory {
    private var layoutInflater: LayoutInflater

    init {
        this.layoutInflater = layoutInflater
    }

    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val adView: NativeAdView = layoutInflater.inflate(R.layout.large_native_layout, null) as NativeAdView

        adView.headlineView = adView.findViewById(R.id.large_native_layout_header_id)
        adView.bodyView = adView.findViewById(R.id.large_native_layout_body_id)
        adView.iconView = adView.findViewById(R.id.large_native_layout_icon_id)
        adView.callToActionView = adView.findViewById(R.id.large_native_layout_cta_id)
        adView.mediaView = adView.findViewById(R.id.large_native_layout_media_id)

        if (nativeAd.headline == null) {
            adView.headlineView?.visibility = android.view.View.GONE
        } else {
            (adView.headlineView as TextView).text = nativeAd.headline
            adView.headlineView?.visibility = android.view.View.VISIBLE
        }

        if (nativeAd.body == null) {
            adView.bodyView?.visibility = android.view.View.GONE
        } else {
            (adView.bodyView as TextView).text = nativeAd.body
            adView.bodyView?.visibility = android.view.View.VISIBLE
        }

        if (nativeAd.icon == null) {
            adView.iconView?.visibility = android.view.View.GONE
        } else {
            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon?.drawable)
            adView.iconView?.visibility = android.view.View.VISIBLE
        }

        if (nativeAd.callToAction == null) {
            adView.callToActionView?.visibility = android.view.View.GONE
        } else {
            (adView.callToActionView as TextView).text = nativeAd.callToAction
            adView.callToActionView?.visibility = android.view.View.VISIBLE
        }

        if (nativeAd.mediaContent == null) {
            adView.mediaView?.visibility = android.view.View.GONE
        } else {
            adView.mediaView?.visibility = android.view.View.VISIBLE
            adView.mediaView?.mediaContent = nativeAd.mediaContent
        }

        adView.setNativeAd(nativeAd)

        return adView
    }
}