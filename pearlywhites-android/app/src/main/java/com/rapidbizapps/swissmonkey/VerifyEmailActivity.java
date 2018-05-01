package com.rapidbizapps.swissmonkey;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.JsonObject;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;
import com.rba.dialog.util.DialogUtils;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class VerifyEmailActivity extends AppCompatActivity implements View.OnClickListener {

    final int SPLASH_TIME_OUT = 5000;
    Context context;
    TextView tv_headerText;
    ImageView iv_backArrow;
    String successMessage;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_verify_email);
        context = VerifyEmailActivity.this;
        initializeUiElements();

        Intent extras = getIntent();
        if (extras != null) {
            successMessage = extras.getStringExtra(Constants.SUCCESS_MESSAGE);
        }

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                Intent i = new Intent(VerifyEmailActivity.this, LoginActivity.class);
                startActivity(i);
                finish();
            }

        }, SPLASH_TIME_OUT);
    }

    private void initializeUiElements() {
        iv_backArrow = (ImageView) findViewById(R.id.iv_backArrow);
        iv_backArrow.setOnClickListener(this);
        tv_headerText = (TextView) findViewById(R.id.tv_headerText);
        tv_headerText.setText("Step 2/2");
        tv_headerText.setTextColor(getResources().getColor(R.color.purple));
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        Intent intent = new Intent(context, LoginActivity.class);
        startActivity(intent);
        //overridePendingTransition(R.anim.fade_in,R.anim.fade_out);
        finish();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_backArrow:
                onBackPressed();
                break;
        }

    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }

}
