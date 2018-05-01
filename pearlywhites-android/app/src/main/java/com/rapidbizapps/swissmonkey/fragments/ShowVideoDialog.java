package com.rapidbizapps.swissmonkey.fragments;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.DialogFragment;
import android.app.ProgressDialog;
import android.graphics.PixelFormat;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.MediaController;
import android.widget.VideoView;

import com.rapidbizapps.swissmonkey.R;

/**
 * Created by kkalluri on 7/21/2016.
 */
public class ShowVideoDialog extends DialogFragment {

    Activity actv;
    ProgressDialog pDialog;
    VideoView videoview;
    String mVideoUrl;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        actv=activity;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

       Bundle bundle= getArguments();
        if(bundle!=null)
        mVideoUrl= bundle.getString("video_url");

    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        getDialog().getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        View view = inflater.inflate(R.layout.video_dialog_layout, null);


// Find your VideoView in your video_main.xml layout
        videoview = (VideoView) view.findViewById(R.id.video_view);



        // Execute StreamVideo AsyncTask

        // Create a progressbar
        pDialog = new ProgressDialog(actv);
        // Set progressbar message
        pDialog.setMessage("Buffering...");
        pDialog.setIndeterminate(false);
        pDialog.setCancelable(false);
        // Show progressbar
        pDialog.show();

        try {
            // Start the MediaController
            getDialog().getWindow().setFormat(PixelFormat.TRANSLUCENT);
            MediaController mediacontroller = new MediaController(actv);
            mediacontroller.setAnchorView(videoview);
            // Get the URL from String VideoURL
            Uri video = Uri.parse(mVideoUrl);
            videoview.setMediaController(mediacontroller);
            videoview.setVideoURI(video);



        } catch (Exception e) {
            Log.e("Error", e.getMessage());
            e.printStackTrace();
        }

        videoview.requestFocus();
        videoview.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            // Close the progress bar and play the video
            public void onPrepared(MediaPlayer mp) {
                pDialog.dismiss();
                videoview.start();
            }
        });


        videoview.setOnErrorListener(new MediaPlayer.OnErrorListener() {
            @Override
            public boolean onError(MediaPlayer mp, int what, int extra) {
                pDialog.dismiss();
                return false;
            }
        });


        return view;


    }
}
