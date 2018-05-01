package com.rapidbizapps.swissmonkey.fragments;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

public class SettingsFragment extends Fragment implements View.OnClickListener {

    Context context;
    ImageView iv_profileImage;
    TextView tv_resetPassword, tv_deactivateAccount, profileName;

    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private HomeActivity mActivity;

    public SettingsFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment SettingsFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static SettingsFragment newInstance(String param1, String param2) {
        SettingsFragment fragment = new SettingsFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_settings, container, false);
        context = getActivity();
        initializeUiElements(rootView);
        ((HomeActivity) getActivity()).hideSaveButton();
        ((HomeActivity) getActivity()).hideNotification();
        //method to access the profile image
        if (Profile.getInstance().getProfilePic() != null && Profile.getInstance().getProfilePic().length() > 0) {
            getprofileImage();
        } else {
            getProfileData();
        }
        String name = PreferencesData.getString(getActivity(), Constants.PROFILE_NAME, "");
        if (name.length() > 0) {
            profileName.setText(name);
        } else {
            profileName.setText(Profile.getInstance().getName());
        }


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
        // create bitmap from resource
        Bitmap bm = BitmapFactory.decodeResource(getResources(),
                R.drawable.logo);
        // set circle bitmap
        iv_profileImage = (ImageView) view.findViewById(R.id.profile_pic_settings);
        //     iv_profileImage.setImageBitmap(getCircleBitmap(bm));

        profileName = (TextView) view.findViewById(R.id.profileName);
        tv_resetPassword = (TextView) view.findViewById(R.id.tv_resetPassword);
        tv_resetPassword.setOnClickListener(this);
        tv_deactivateAccount = (TextView) view.findViewById(R.id.tv_deactivateAccount);
        tv_deactivateAccount.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_resetPassword:
                //TODO implement the method
                //Toast.makeText(getActivity(), "reset clicked", Toast.LENGTH_LONG).show();
                showDialogtoChangePassword(getActivity());
                break;
            case R.id.tv_deactivateAccount:
                //Todo implement the method
                // Toast.makeText(getActivity(), "deactivate clicked", Toast.LENGTH_LONG).show();
                showDialogForDeactivateAccount();
                break;
        }
    }

    public void getprofileImage() {
        //set profile picture
        String authHeader = PreferencesData.getString(getActivity(), Constants.AUTHORIZATION_KEY, "");
        JsonObject profileRequest = new JsonObject();
        profileRequest.addProperty(Constants.AUTH_TOKEN_KEY, authHeader);
        profileRequest.addProperty(Constants.TYPE_KEY, "profile");
        profileRequest.addProperty("file", Profile.getInstance().getProfilePic());

        RetroHelper.getBaseClassService(getActivity(), "", "").downloadFiles(profileRequest, new Callback<JsonObject>() {
            @Override
            public void success(JsonObject jsonObject, Response response) {
                if (jsonObject != null) {
                    JsonElement url = jsonObject.get("url");
                    ImageLoader.getInstance().displayImage(url.getAsString(), iv_profileImage, Utility.getProfilePicDisplayOptions(Constants.CIRCULAR_IMAGE_RADIUS));
                }
            }

            @Override
            public void failure(RetrofitError error) {
                Utility.serviceCallFailureMessage(error,mActivity);
            }
        });
    }

    public void getProfileData() {

        String authHeader = PreferencesData.getString(getActivity(), Constants.AUTHORIZATION_KEY, "");

        JsonObject profileJsonObject = new JsonObject();
        profileJsonObject.addProperty(Constants.AUTH_TOKEN_KEY, authHeader);

        if (Utility.isConnectingToInternet(getActivity())) {
            Utility.showProgressDialog(getActivity());
            RetroHelper.getBaseClassService(getActivity(), "", authHeader).getProfileData(profileJsonObject, new Callback<Profile>() {

                @Override
                public void success(Profile profile, Response response) {
                    Utility.dismissDialog();
                    Log.d("Response", profile.toString());

                    Profile.setInstance(profile);
                    getprofileImage();
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    Utility.serviceCallFailureMessage(error, getActivity());
                }
            });
        } else {
            Toast.makeText(getActivity(), "Please check your network connection", Toast.LENGTH_SHORT).show();
        }

    }

    public void showDialogForDeactivateAccount() {
        final Dialog dialog = new Dialog(getActivity());
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_two_button_layout);
        //   dialog.getWindow().setBackgroundDrawableResource(android.R.color.white);
        TextView title = (TextView) dialog.findViewById(R.id.dialog_title);
        title.setText("Swiss Monkey");
        TextView messageText = (TextView) dialog.findViewById(R.id.messageText);
        messageText.setText("Do you want to Deactivate your account?");
        TextView btNo = (TextView) dialog.findViewById(R.id.btNo);
        btNo.setText("YES");
        TextView btyes = (TextView) dialog.findViewById(R.id.btYes);
        btyes.setText("NO");


        btyes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //resideMenu.closeMenu();
                dialog.dismiss();
            }
        });
        btNo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deactivateUser();
                dialog.dismiss();
            }
        });
        dialog.show();
    }

    public void deactivateUser() {

        String authHeader = PreferencesData.getString(getActivity(), Constants.AUTHORIZATION_KEY, "");
        JsonObject deactivateUserJsonObject = new JsonObject();
        deactivateUserJsonObject.addProperty("authtoken", authHeader);
        if (Utility.isConnectingToInternet(context)) {
            Utility.showProgressDialog(context);
            RetroHelper.getBaseClassService(getActivity(), "", "").deactivateAccount(deactivateUserJsonObject, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();
                    if (jsonObject != null && jsonObject.toString().length() > 0) {
                        Log.d("SUCCESS sendcode", jsonObject.toString());
                        //     Toast.makeText(context,jsonObject.get("success").toString(),Toast.LENGTH_LONG).show();
                        showDialogToConfirmDeactivation();
                    }
                }

                @Override
                public void failure(RetrofitError retrofitError) {
                        Utility.dismissDialog();
                        Utility.serviceCallFailureMessage(retrofitError, getActivity());
                }
            });
        } else {
            Toast.makeText(context, "Please check internet connection", Toast.LENGTH_LONG).show();
        }
    }

    public void showDialogToConfirmDeactivation() {
        //final HomeActivity homeActivity = new HomeActivity();
        final Dialog dialog = new Dialog(getActivity());
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_single_button_layout);
        //   dialog.getWindow().setBackgroundDrawableResource(android.R.color.white);
        TextView title = (TextView) dialog.findViewById(R.id.dialog_title);
        title.setText(Constants.APP_NAME);
        TextView messageText = (TextView) dialog.findViewById(R.id.messageText);
        messageText.setText("You have deactivated your account and will be logged out from the application.");
        dialog.findViewById(R.id.btOK).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((HomeActivity) getActivity()).logoutUser();
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    public void showDialogtoChangePassword(final Activity activity) {

        final Dialog dialog = new Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_with_two_edittext_layout);
        dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
        TextView title = (TextView) dialog.findViewById(R.id.dialog_title);
        TextView btOK = (TextView) dialog.findViewById(R.id.btOK);
        TextView btCancel = (TextView) dialog.findViewById(R.id.btCancel);

        final EditText et_oldPassword = (EditText) dialog.findViewById(R.id.et_oldPassword);
        final EditText et_newPassword = (EditText) dialog.findViewById(R.id.et_newPassword);

        btOK.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {

                                        String authHeader = PreferencesData.getString(activity, Constants.AUTHORIZATION_KEY, "");
                                        JsonObject forgotPasswordJsonObject = new JsonObject();

                                        if (et_oldPassword.getText().toString().length() == 0 || et_newPassword.getText().length() == 0) {
                                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.REQUIRED_FIELDS);
                                        } else if (et_newPassword.getText().toString().length() < 8) {
                                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.INVALID_PASSWORD_LENGTH);
                                        } else {

                                            //  String authHeader = PreferencesData.getString(getActivity(), Constants.AUTHORIZATION_KEY, "");
                                            JsonObject resetPasswordJsonObject = new JsonObject();

                                            resetPasswordJsonObject.addProperty("authtoken", authHeader);
                                            resetPasswordJsonObject.addProperty("oldpassword", et_oldPassword.getText().toString());
                                            resetPasswordJsonObject.addProperty("newpassword", et_newPassword.getText().toString());

                                            if (Utility.isConnectingToInternet(getActivity())) {
                                                Utility.showProgressDialog(getActivity());
                                                RetroHelper.getBaseClassService(getActivity(), "", authHeader).resetPassword(resetPasswordJsonObject, new Callback<JsonObject>() {
                                                    @Override
                                                    public void success(JsonObject jsonObject, Response response) {
                                                        Utility.dismissDialog();
                                                        dialog.dismiss();
                                                        if (jsonObject != null && jsonObject.toString().length() > 0) {

                                                            Log.d("SUCCESS ", jsonObject.toString());

                                                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Updated password successfully");
                                                        }
                                                    }

                                                    @Override
                                                    public void failure(RetrofitError retrofitError) {
                                                        Utility.dismissDialog();
                                                        dialog.dismiss();
                                                        Utility.serviceCallFailureMessage(retrofitError, getActivity());
                                                    }
                                                });
                                            } else {
                                                DialogUtility.showDialogWithOneButton(getActivity(), Constants.NO_NETWORK_HEADER, Constants.NO_NETWORK);
                                            }


                                        }

                                    }
                                }

        );

        btCancel.setOnClickListener(new View.OnClickListener()

                                    {
                                        @Override
                                        public void onClick(View v) {
                                            dialog.dismiss();
                                        }
                                    }

        );
        dialog.show();
    }


    public void resetPassword(String newPassword, String oldPassword) {

        String authHeader = PreferencesData.getString(getActivity(), Constants.AUTHORIZATION_KEY, "");
        JsonObject resetPasswordJsonObject = new JsonObject();

        if (newPassword.length() == 0 || oldPassword.length() == 0) {
            DialogUtility.showDialogWithOneButton(getActivity(), Constants.APP_NAME, Constants.REQUIRED_FIELDS);
        } else {

            resetPasswordJsonObject.addProperty("authtoken", authHeader);
            resetPasswordJsonObject.addProperty("oldpassword", oldPassword);
            resetPasswordJsonObject.addProperty("newpassword", newPassword);

            if (Utility.isConnectingToInternet(getActivity())) {
                Utility.showProgressDialog(getActivity());
                RetroHelper.getBaseClassService(getActivity(), "", authHeader).resetPassword(resetPasswordJsonObject, new Callback<JsonObject>() {
                    @Override
                    public void success(JsonObject jsonObject, Response response) {
                        Utility.dismissDialog();
                        if (jsonObject != null && jsonObject.toString().length() > 0) {

                            Log.d("SUCCESS ", jsonObject.toString());
                            //  Toast.makeText(context, jsonObject.get("authtoken").getAsString(), Toast.LENGTH_LONG).show();

                         /*   PreferencesData.saveString(context, Constants.AUTHORIZATION_KEY, jsonObject.get("authtoken").getAsString());
                            PreferencesData.saveString(context,Constants.USERNAME, et_username.getText().toString().trim());
                            Intent i = new Intent(context, HomeActivity.class);
                            startActivity(i);
                            finish();*/
                        }
                    }

                    @Override
                    public void failure(RetrofitError retrofitError) {
                            Utility.dismissDialog();
                            Utility.serviceCallFailureMessage(retrofitError, getActivity());
                    }
                });
            } else {
                DialogUtility.showDialogWithOneButton(getActivity(), Constants.NO_NETWORK_HEADER, Constants.NO_NETWORK);
            }
        }

    }


}
