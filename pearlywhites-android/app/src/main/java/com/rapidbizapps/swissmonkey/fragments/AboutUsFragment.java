package com.rapidbizapps.swissmonkey.fragments;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.Utility;

public class AboutUsFragment extends Fragment implements View.OnClickListener {

    private static final int CALL_PERMISSION_REQUEST = 999;
    TextView tv_emailUs, tv_callUs;
    Context context;
    private HomeActivity mActivity;

    public AboutUsFragment() {
        // Required empty public constructor
    }

    public static AboutUsFragment newInstance(String param1, String param2) {
        AboutUsFragment fragment = new AboutUsFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_about_us, container, false);
        initializeUiElements(rootView);

        mActivity.hideSaveButton();
        mActivity.hideNotification();
        return rootView;
    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mActivity = (HomeActivity) context;
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }



    public void initializeUiElements(View view) {
        context = getActivity();
        tv_emailUs = (TextView) view.findViewById(R.id.tv_emailUs);
        tv_emailUs.setText(Html.fromHtml(mActivity.getResources().getString(R.string.emailUs)));
        tv_emailUs.setOnClickListener(this);
        tv_callUs = (TextView) view.findViewById(R.id.tv_callUs);
        tv_callUs.setText(Html.fromHtml(mActivity.getResources().getString(R.string.callUs)));
        tv_callUs.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_emailUs:
                Utility.sendEmail(mActivity, "", "Feedback", Constants.EMAILTO);
                break;

            case R.id.tv_callUs:
                if (ActivityCompat.checkSelfPermission(mActivity, Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
                    callPhone(Constants.CALLTO);
                } else {
                    requestPermissions(new String[]{Manifest.permission.CALL_PHONE}, CALL_PERMISSION_REQUEST);
                }
        }
    }


    public void callPhone(String phone) {
        if (phone != null) {
            Intent callIntent = new Intent(Intent.ACTION_CALL);
            callIntent.setData(Uri.parse("tel:" + phone.trim()));
            startActivity(callIntent);
        }

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == CALL_PERMISSION_REQUEST) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                callPhone(Constants.CALLTO);
            }
        }
    }
}
