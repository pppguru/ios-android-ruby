package com.rapidbizapps.swissmonkey.utility;

import android.content.Context;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Environment;
import android.util.Log;

import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.profile.DownloadCompleteCallback;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

/**
 * Created by mlanka on 24-06-2016.
 */
public class DownloadFileTask extends AsyncTask<String, Void, Void> {

    private static final String LOG_TAG = DownloadFileTask.class.getSimpleName();
    private final int TIMEOUT_CONNECTION = 5000;//5sec
    private final int TIMEOUT_SOCKET = 30000;//30sec

    Context mContext;
    DownloadCompleteCallback callback;
    int index;

    public DownloadFileTask(Context context, DownloadCompleteCallback callback) {
        mContext = context;
        this.callback=callback;

    }

    @Override
    protected Void doInBackground(String... params) {

         index=Integer.parseInt(params[0]);
        Log.e("doInBackground","index "+ index +", video url : "+ProfileHelper.getInstance().getVideoUrls()[index]);

            File file = downloadVideo(ProfileHelper.getInstance().getVideoUrls()[index],index);
            if (file != null) {
                ProfileHelper.getInstance().getVideoUris()[index] = Uri.fromFile(file);

            }


        return null;
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        Log.d(LOG_TAG, "onPreExecute: ");

    }


    @Override
    protected void onPostExecute(Void aVoid) {
        super.onPostExecute(aVoid);

        callback.done(index+1);
        Log.d(LOG_TAG, "onPostExecute: ");
        PreferencesData.saveBoolean(mContext, Constants.DOWNLOAD_VIDEOS, false); //videos downloaded. do not download again
    }

    File downloadVideo(String imageURL,int index) {
        URL url;
        File file;

        try {
            url = new URL(imageURL);

            //String rootDir = Environment.getExternalStorageDirectory() + File.separator + ".rapidBizApps/";
            File root = new File(Constants.baseUrl);
            root.mkdirs();

            String imagePath = ProfileHelper.getInstance().getVidoesArray()[index];
            Log.e("doInBackGround","image Path : "+imagePath);
            file = new File(root, imagePath);

            Log.e("doInBackGround","create file Path : "+file.getAbsolutePath());
            file.createNewFile();

            ProfileHelper.getInstance().getVideoUrls()[index]=file.getAbsolutePath();

            long startTime = System.currentTimeMillis();
            Log.i(LOG_TAG, "video download beginning: " + file.getAbsolutePath());

            //Open a connection to that URL.
            URLConnection ucon = url.openConnection();

            //this timeout affects how long it takes for the app to realize there's a connection problem
            ucon.setReadTimeout(TIMEOUT_CONNECTION);
            ucon.setConnectTimeout(TIMEOUT_SOCKET);

            //Define InputStreams to read from the URLConnection uses 3KB download buffer
            InputStream is = ucon.getInputStream();
            BufferedInputStream inStream = new BufferedInputStream(is, 1024 * 5);
            FileOutputStream outStream = new FileOutputStream(file);
            byte[] buff = new byte[5 * 1024];

            //Read bytes (and store them) until there is nothing more to read(-1)
            int len;
            while ((len = inStream.read(buff)) != -1) {
                outStream.write(buff, 0, len);
            }

            //clean up
            outStream.flush();
            outStream.close();
            inStream.close();

            Log.i(LOG_TAG, "download completed in " + ((System.currentTimeMillis() - startTime) / 1000) + " sec");

            return file;

        } catch (MalformedURLException e) {
            Log.e(LOG_TAG, "downloadVideo: " + e.getMessage());
        } catch (IOException e) {
            Log.e(LOG_TAG, "downloadVideo: " + e.getMessage());
        }


        return null;
    }


}
