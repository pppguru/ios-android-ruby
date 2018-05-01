package com.rapidbizapps.swissmonkey.utility;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.JsonObject;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * Created by mjain on 5/25/2016.
 */
public class DialogUtility {

    private static final String LOG_TAG = "DialogUtility";

    public static void showDialogWithUploadOptions(final Activity activity) {
        final Dialog dialog = new Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_upload_option);

        dialog.findViewById(R.id.tv_album).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // TODO select and upload picture

            }
        });

        dialog.findViewById(R.id.tv_camera).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // TODO select and upload video
            }
        });

        dialog.findViewById(R.id.btCancel).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    public interface PositiveButtonCallback {
        void onPositiveButtonClick(Dialog dialog);
    }

    public interface NegativeButtonCallback {
        void onNegativeButtonClick(Dialog dialog);
    }


    //Single ok button normal dialog box (no material design  )
    public static void showDialogWithOneButton(final Activity activity, String header, String msg, View.OnClickListener buttonListener) {
        final Dialog dialog = new Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_single_button_layout);
        //   dialog.getWindow().setBackgroundDrawableResource(android.R.color.white);
        TextView title = (TextView) dialog.findViewById(R.id.dialog_title);
        title.setText(header);
        TextView messageText = (TextView) dialog.findViewById(R.id.messageText);
        messageText.setText(msg);
        dialog.findViewById(R.id.btOK).setOnClickListener(buttonListener);
        dialog.show();
    }


    //Single ok button normal dialog box (no material design  )
    public static void showDialogWithOneButton(final Activity activity, String header, String msg) {
        final Dialog dialog = new Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_single_button_layout);
        //   dialog.getWindow().setBackgroundDrawableResource(android.R.color.white);
        TextView title = (TextView) dialog.findViewById(R.id.dialog_title);
        title.setText(header);
        TextView messageText = (TextView) dialog.findViewById(R.id.messageText);
        messageText.setText(msg);
        dialog.findViewById(R.id.btOK).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    public static void showTermsAndConditionsDialog(final Activity activity, final boolean postStatus, final CheckBox checkBox) {
        final Dialog dialog = new Dialog(activity);
        dialog.setCancelable(false);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.terms_and_conditions);
        //   dialog.getWindow().setBackgroundDrawableResource(android.R.color.white);
        TextView messageText = (TextView) dialog.findViewById(R.id.messageText);
        messageText.setMovementMethod(new ScrollingMovementMethod());
        messageText.setText(Utility.parseFileToString(activity, "tandc.txt"));
        dialog.findViewById(R.id.btOK).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (postStatus) {
                    Log.d(LOG_TAG, "onClick: posting status");
                    Utility.showProgressDialog(activity);
                    JsonObject requestBody = new JsonObject();
                    requestBody.addProperty(Constants.EMAIL_KEY, PreferencesData.getString(activity, Constants.USERNAME, ""));
                    RetroHelper.getBaseClassService(activity, "", "").acceptToA(requestBody, new Callback<JsonObject>() {
                        @Override
                        public void success(JsonObject jsonObject, Response response) {
                            dialog.dismiss();
                            Utility.dismissDialog();
                            //keep the local flag. used to check later in onResume
                            PreferencesData.saveBoolean(activity, Constants.TERMS_AND_CONDITIONS_ACCEPTED, true);

                            Intent i = new Intent(activity, HomeActivity.class);
                            activity.startActivity(i);
                            activity.finish();

                            Log.d(LOG_TAG, "success: navigating to home");
                        }

                        @Override
                        public void failure(RetrofitError error) {
                            dialog.dismiss();
                            Utility.dismissDialog();
                            Utility.serviceCallFailureMessage(error, activity);
                            PreferencesData.saveBoolean(activity, Constants.TERMS_AND_CONDITIONS_ACCEPTED, true); // TODO: 26-08-2016 call failed, but this has to be updated in the server again! How?
                        }
                    });
                } else {
                    Log.d(LOG_TAG, "onClick: not posting status");
                    dialog.dismiss();
                    if (checkBox != null)
                        checkBox.setChecked(true);
                }
            }
        });
        dialog.show();
    }


    //Single ok button normal dialog box (no material design  )
    public static Dialog showDialogWithTwoButtons(final Activity activity, String header, String msg) {
        final Dialog dialog = new Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_single_button_layout);
        //   dialog.getWindow().setBackgroundDrawableResource(android.R.color.white);
        TextView title = (TextView) dialog.findViewById(R.id.dialog_title);
        title.setText(header);
        TextView messageText = (TextView) dialog.findViewById(R.id.messageText);
        messageText.setText(msg);
        dialog.findViewById(R.id.btOK).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialog.show();
        return dialog;
    }


    public static void showDialogWithTwoButtons(final Activity activity, String header, String message, final JsonObject jsonObject) {
        final Dialog dialog = new Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_yes_no_option);

        ((TextView) (dialog.findViewById(R.id.dialog_title))).setText(header);
        ((TextView) (dialog.findViewById(R.id.dialog_message))).setText(message);


        dialog.findViewById(R.id.yes_btn).setOnClickListener(new View.OnClickListener() {
                                                                 @Override
                                                                 public void onClick(View v) {
                                                                     if (Utility.isConnectingToInternet(activity)) {
                                                                         Utility.showProgressDialog(activity);
                                                                         RetroHelper.getBaseClassService(activity, "", "").applyNow(jsonObject, new Callback<JsonObject>() {
                                                                                     @Override
                                                                                     public void success(JsonObject jsonObject1, Response response) {
                                                                                         dialog.dismiss();
                                                                                         Utility.dismissDialog();
                                                                                         if (jsonObject1.has(Constants.SUCCESS_RESPONSE_KEY)) {
                                                                                             if (jsonObject1.get(Constants.SUCCESS_RESPONSE_KEY).getAsString().contains("Already")) {
                                                                                                 DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Already applied for the job");
                                                                                             } else if (jsonObject1.get(Constants.SUCCESS_RESPONSE_KEY).getAsString().contains("You cannot apply for this job")) {
                                                                                                 DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "You cannot apply for this job!");
                                                                                             } else {
                                                                                                 DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Application successfully sent!");
                                                                                             }


                                                                                         }
                                                                                     }

                                                                                     @Override
                                                                                     public void failure(RetrofitError error) {
                                                                                         dialog.dismiss();
                                                                                         Utility.dismissDialog();
                                                                                         Utility.serviceCallFailureMessage(error, activity);
                                                                                     }
                                                                                 }

                                                                         );

                                                                     } else {
                                                                         dialog.dismiss();
                                                                         Toast.makeText(activity, "Please check internet connection", Toast.LENGTH_LONG).show();
                                                                     }

                                                                 }
                                                             }

        );

        dialog.findViewById(R.id.no_btn).

                setOnClickListener(new View.OnClickListener() {
                                       @Override
                                       public void onClick(View v) {
                                           dialog.dismiss();
                                       }
                                   }

                );

        dialog.show();
    }


    public static void showDialogWithEditText(final Activity activity) {

        final Dialog dialog = new Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_with_edittext);
        dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
        TextView title = (TextView) dialog.findViewById(R.id.dialog_title);
        TextView messageText = (TextView) dialog.findViewById(R.id.messageText);
        TextView btOK = (TextView) dialog.findViewById(R.id.btOK);
        TextView btCancel = (TextView) dialog.findViewById(R.id.btCancel);

        final EditText et_email = (com.rba.MaterialEditText) dialog.findViewById(R.id.et_email);

        btOK.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        String authHeader = PreferencesData.getString(activity, Constants.AUTHORIZATION_KEY, "");
                                        JsonObject forgotPasswordJsonObject = new JsonObject();

                                        if (et_email.getText().toString().length() == 0) {
                                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.ENTER_EMAIL);
                                        } else if (!Utility.isValidEmail(et_email.getText().toString().trim())) {
                                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.INVALID_EMAIL);
                                        } else {

                                            forgotPasswordJsonObject.addProperty("username", et_email.getText().toString());
                                            // loginUserJsonObject.addProperty("password", et_password.getText().toString());

                                            if (Utility.isConnectingToInternet(activity)) {
                                                Utility.showProgressDialog(activity);
                                                RetroHelper.getBaseClassService(activity, "", authHeader).forgotPassword(forgotPasswordJsonObject, new Callback<JsonObject>() {
                                                    @Override
                                                    public void success(JsonObject jsonObject, Response response) {
                                                        if (jsonObject != null && jsonObject.toString().length() > 0) {
                                                            Utility.dismissDialog();
                                                            Log.d("SUCCESS ", jsonObject.toString());
                                                            dialog.dismiss();
                                                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, jsonObject.get("success").getAsString());
                                                        }
                                                    }

                                                    @Override
                                                    public void failure(RetrofitError retrofitError) {
                                                        Utility.dismissDialog();
                                                        dialog.dismiss();
                                                        Utility.serviceCallFailureMessage(retrofitError, activity);
                                                    }
                                                });
                                            } else {
                                                DialogUtility.showDialogWithOneButton(activity, Constants.NO_NETWORK_HEADER, Constants.NO_NETWORK);
                                            }
                                        }

                                    }
                                }

        );

        btCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });
        dialog.show();
    }


    public static void showDialogWithTwoButtons(final Activity activity, String header, String message, View.OnClickListener positiveListener, String positiveText, String negativeText) {
        final Dialog dialog = new Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_two_button_layout);

        ((TextView) (dialog.findViewById(R.id.dialog_title))).setText(header);
        ((TextView) (dialog.findViewById(R.id.messageText))).setText(message);

        TextView positiveButton = (TextView) dialog.findViewById(R.id.btYes);
        positiveButton.setOnClickListener(positiveListener);
        positiveButton.setText(positiveText);

        TextView negativeButton = (TextView) dialog.findViewById(R.id.btNo);
        negativeButton.setText(negativeText);

        negativeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });


        dialog.show();
    }

    public static void completeProfileAlert(final Activity activity, String header, String message, final PositiveButtonCallback positiveButtonCallback, final NegativeButtonCallback negativeButtonCallback, String positiveText, String negativeText) {
        final Dialog dialog = new Dialog(activity);
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.dialog_two_button_layout);

        ((TextView) (dialog.findViewById(R.id.dialog_title))).setText(header);
        ((TextView) (dialog.findViewById(R.id.messageText))).setText(message);

        final TextView positiveButton = (TextView) dialog.findViewById(R.id.btYes);
        positiveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                positiveButtonCallback.onPositiveButtonClick(dialog);
            }
        });
        positiveButton.setText(positiveText);

        TextView negativeButton = (TextView) dialog.findViewById(R.id.btNo);
        negativeButton.setText(negativeText);

        negativeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                negativeButtonCallback.onNegativeButtonClick(dialog);
            }
        });


        dialog.show();
    }


}
