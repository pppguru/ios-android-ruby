package com.rapidbizapps.swissmonkey.utility;

import android.app.Application;
import android.net.Uri;

import com.crashlytics.android.Crashlytics;
import com.flurry.android.FlurryAgent;
import com.nostra13.universalimageloader.cache.memory.impl.LruMemoryCache;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.rapidbizapps.swissmonkey.R;

import io.fabric.sdk.android.Fabric;
import uk.co.chrisjenx.calligraphy.CalligraphyConfig;

/**
 * Created by mjain on 5/20/2016.
 */
public class SwissMonkeyApplication extends Application {


    private static final String LOG_TAG = "SwissMonkeyApplication";
    public static Uri[] videoUris = new Uri[3];
    public static Uri[] photosUri = new Uri[3];
    public static Uri[] resumeUris = new Uri[5];
    public static Uri[] lorUris = new Uri[3];
    public static Uri profilePicUri;

    @Override
    public void onCreate() {
        super.onCreate();
        Fabric.with(this, new Crashlytics());

        FlurryAgent.init(this, Constants.FLURRY_APIKEY);

        // Create global configuration and initialize ImageLoader with this config
        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(this)
                .memoryCache(new LruMemoryCache(2 * 1024 * 1024))
                .defaultDisplayImageOptions(DisplayImageOptions.createSimple())
                .writeDebugLogs()
                .build();

        ImageLoader.getInstance().init(config);

        CalligraphyConfig.initDefault(new CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/Roboto-RobotoRegular.ttf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        );

    }

}
