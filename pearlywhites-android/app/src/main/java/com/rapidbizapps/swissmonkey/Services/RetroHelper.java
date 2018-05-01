package com.rapidbizapps.swissmonkey.Services;

import android.content.Context;
import android.util.Log;

import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.squareup.okhttp.OkHttpClient;

import java.util.concurrent.TimeUnit;

import retrofit.RequestInterceptor;
import retrofit.RestAdapter;
import retrofit.client.OkClient;

public class RetroHelper {
    private static final String LOG_TAG = RetroHelper.class.getSimpleName();

//    public static final String API_BASE_URL = "http://swissmonkey-test.rapidbizapps.com/api/v1.0";

    public static final String API_BASE_URL = "http://checkup.swissmonkey.co/api/v1.0";


    Context mContext;

    // Production server
    // public static final String API_BASE_URL = "https://app.swissmonkey.co/api/v1.0";

    //   private static OkHttpClient.Builder httpClient = new OkHttpClient.Builder();

    public static RestAdapter getAdapter(Context context, String endpoint, String header) {

//        String url = API_BASE_URL + endpoint;
        String url = context.getString(R.string.server_url) + endpoint;
        //String url = endpoint;
        Log.e("KAR", "getAdapter url :: " + url);
        OkHttpClient client = new OkHttpClient();
        client.setConnectTimeout(60, TimeUnit.SECONDS); // connect timeout
        client.setReadTimeout(60, TimeUnit.SECONDS);    // socket timeout


        RestAdapter restAdapter = new RestAdapter.Builder()
                .setEndpoint(url)
                .setRequestInterceptor(getRequestInterceptor(header))
                .setLogLevel(RestAdapter.LogLevel.HEADERS_AND_ARGS).setLog(new RestAdapter.Log() { //setting to log level FULL causes Out of Memory Error!!
                    @Override
                    public void log(String msg) {
                        Log.e("Retro Helper", msg);
                    }
                })
                .setClient(new OkClient(client))
                .build();

        return restAdapter;
    }

    private static RequestInterceptor getRequestInterceptor(final String header) {
        RequestInterceptor requestInterceptor = new RequestInterceptor() {
            @Override
            public void intercept(RequestFacade request) {
                if (header != null) {
                    request.addHeader(Constants.AUTHORIZATION_KEY, header);
                }

                request.addHeader("version", "4.0");
            }
        };

        return requestInterceptor;
    }

    public static ServiceHelper getBaseClassService(Context context, String url, String header) {
        return new RetroHelper().getAdapter(context, url, header).create(ServiceHelper.class);
    }


}
