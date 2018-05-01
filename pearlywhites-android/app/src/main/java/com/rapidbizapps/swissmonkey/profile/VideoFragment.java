package com.rapidbizapps.swissmonkey.profile;

import android.app.Activity;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.ProgressDialog;
import android.graphics.PixelFormat;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.TextView;
import android.widget.VideoView;


import com.rapidbizapps.swissmonkey.R;

/**
 * Created by kkalluri on 7/4/2016.
 */
public class VideoFragment extends DialogFragment {
    private String selectedURL;
    private Activity actv;
    VideoView videoView;
   ProgressDialog progressDialog;
    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        actv = activity;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        Bundle bundle = getArguments();
        if (bundle != null) {
            selectedURL = bundle.getString("url");
            Log.e("onCreate","selectedUrl: "+selectedURL);
        }


    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_dialog, container, false);

         videoView = (VideoView) v.findViewById(R.id.fragment_dialog_videourl);


        progressDialog = ProgressDialog.show(actv, "", "Buffering video...",true);
        progressDialog.setCancelable(true);
        PlayVideo();
        return v;
    }

    private void PlayVideo()
    {
        try
        {
            videoView.setVideoPath(selectedURL);
            videoView.setMediaController(new MediaController(actv));
            videoView.requestFocus();
            videoView.start();
        }
        catch(Exception e)
        {
            progressDialog.dismiss();
            System.out.println("Video Play Error :"+e.toString());

        }

    }
}