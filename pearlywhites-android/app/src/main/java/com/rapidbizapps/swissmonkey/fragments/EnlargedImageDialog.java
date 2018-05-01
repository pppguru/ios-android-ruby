package com.rapidbizapps.swissmonkey.fragments;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.decode.BaseImageDecoder;
import com.nostra13.universalimageloader.core.download.BaseImageDownloader;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.io.File;

/**
 * Created by mlanka on 23-06-2016.
 */

public class EnlargedImageDialog extends Activity {

    Intent intent;
    TextView actTitle;
    ImageView actImage;
    ImageButton back_button;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_enlarged_image_dialog);

        actTitle = (TextView) findViewById(R.id.title);
        actImage = (ImageView) findViewById(R.id.enlargedImage);
        intent = getIntent();

        showEnlargedImage();

        back_button = (ImageButton) findViewById(R.id.ib_back);
        back_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent1 = getIntent();
                setResult(Activity.RESULT_CANCELED, intent1);
                finish();
            }
        });

    }

    private void showEnlargedImage() {

        try {
            String imageUrl = intent.getStringExtra("imageUrl");

            if (imageUrl.contains(".rapidBizApps")) {
                imageUrl = Uri.fromFile(new File(imageUrl)).toString();
            }
            ImageLoader imageLoader = ImageLoader.getInstance();
            imageLoader.displayImage(imageUrl, actImage, Utility.getDisplayOptions());
        }catch (Exception e)
        {
            e.printStackTrace();
        }

    }

    @Override
    public void onBackPressed() {
        Intent intent = getIntent();
        setResult(Activity.RESULT_CANCELED, intent);
        finish();
    }
}
