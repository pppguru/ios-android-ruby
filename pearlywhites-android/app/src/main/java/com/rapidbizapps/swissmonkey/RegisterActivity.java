package com.rapidbizapps.swissmonkey;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.method.KeyListener;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.reflect.TypeToken;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.models.Position;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnFocusChange;
import butterknife.OnTouch;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

public class RegisterActivity extends BaseActivity {

    String LOG_TAG = RegisterActivity.this.getClass().getName();
    private List<Position> positions = new ArrayList<>();
    ArrayList<Integer> mSelectedPositions = new ArrayList<>();
    private boolean[] mSelectedPositionArray;

    @BindView(R.id.iv_backArrow)
    ImageView iv_backArrow;

    @BindView(R.id.tv_headerText)
    TextView headerText;

    @BindView(R.id.iv_register)
    ImageView iv_register;

    @BindView(R.id.et_name)
    EditText name;

    @BindView(R.id.et_email)
    EditText email;

    @BindView(R.id.et_password)
    EditText password;

    @BindView(R.id.et_rePassword)
    EditText rePassword;

    @BindView(R.id.et_searchingAs)
    EditText searchingAs;

    @BindView(R.id.show_terms_and_conditions)
    TextView showTermsAndConditions_tv;

    @BindView(R.id.tandc_cb)
    CheckBox tAndC_cb;

    Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        ButterKnife.bind(this);

        mContext = this;
        headerText.setText("Step 1/2");
        headerText.setTextColor(getResources().getColor(R.color.purple));

        KeyListener mKeyListener = searchingAs.getKeyListener();
        searchingAs.setKeyListener(null);
        searchingAs.setFocusable(false);

        Utility.hideKeyboard(this);
        getPositionsFromServer();
        //  initializeUiElements();

        String terms = "I agree to the Terms of Service & Privacy Policy.";
        SpannableString spannableString = new SpannableString("I agree to the Terms of Service & Privacy Policy.");
        ClickableSpan clickableSpan = new ClickableSpan() {
            @Override
            public void onClick(View widget) {
                DialogUtility.showTermsAndConditionsDialog((Activity) mContext, false, tAndC_cb);
            }

        };

        spannableString.setSpan(clickableSpan, 15, terms.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

        showTermsAndConditions_tv.setText(spannableString);
        showTermsAndConditions_tv.setMovementMethod(LinkMovementMethod.getInstance());
        showTermsAndConditions_tv.setHighlightColor(Color.TRANSPARENT);
    }

    public void initializeUiElements() {


     /*   iv_backArrow = (ImageView) findViewById(R.id.iv_backArrow);
        iv_backArrow.setOnClickListener(this);

        iv_register = (ImageView) findViewById(R.id.iv_register);
        iv_register.setOnClickListener(this);

        name = (com.rba.MaterialEditText) findViewById(R.id.et_name);
        email = (com.rba.MaterialEditText) findViewById(R.id.et_email);
        password = (com.rba.MaterialEditText) findViewById(R.id.et_password);
        rePassword = (com.rba.MaterialEditText) findViewById(R.id.et_rePassword);
        searchingAs = (com.rba.MaterialEditText) findViewById(R.id.et_searchingAs);
     */   //getDropDownListData();


        //   name= (com.rapidbizapps.swissmonkey.floatinglabel.FloatingLabelView)findViewById(R.id.et_name);
        //  name.setTextSize(Constants.edittext_textsize);
        //  name.setImeOptions(EditorInfo.IME_ACTION_NEXT);

        //   email = (com.rapidbizapps.swissmonkey.floatinglabel.FloatingLabelView)findViewById(R.id.et_email);
        // email.setImeOptions(EditorInfo.IME_ACTION_DONE);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        Intent intent = new Intent(context, LoginActivity.class);
        startActivity(intent);
        finish();

    }

    @OnClick(R.id.iv_register)
    void onRegister() {
        registerUser();
    }


    @OnClick(R.id.iv_backArrow)
    void onBackClick() {
        onBackPressed();
    }

    @OnFocusChange(R.id.et_searchingAs)
    void onSearchFocuse() {
        Utility.hideKeyboard(RegisterActivity.this);
    }

    @OnClick(R.id.et_searchingAs)
    void onSearchAsTouch() {
        if (positions != null && positions.size() > 0) {
            mSelectedPositions = new ArrayList<>();

            AlertDialog.Builder builder = new AlertDialog.Builder(this, R.style.customAlertDialog);
            CharSequence[] dialogList = new CharSequence[positions.size()];
            // set the dialog title
            for (int i = 0; i < positions.size(); i++) {
                dialogList[i] = positions.get(i).getPositionName();
            }

            // specify the list array, the items to be selected by default (null for none),
            // and the listener through which to receive call backs when items are selected
            // R.array.choices were set in the resources res/values/strings.xml


            builder.setMultiChoiceItems(dialogList, mSelectedPositionArray, new DialogInterface.OnMultiChoiceClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which, boolean isChecked) {

                }
            });

            //set action items
            builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    ListView list = ((AlertDialog) dialog).getListView();
                    // make selected item in the comma separated string
                    StringBuilder stringBuilder = new StringBuilder();
                    for (int i = 0; i < list.getCount(); i++) {
                        boolean checked = list.isItemChecked(i);
                        if (checked) {
                            // if the user checked the item, add it to the selected items
                            mSelectedPositionArray[i] = true;
                            int positionID = positions.get(i).getPositionId();
                            mSelectedPositions.add(positionID);
                        } else {
                            // else if the item is already in the array, remove it
                            mSelectedPositionArray[i] = false;
                            if (mSelectedPositions.size() > 0) {
                                int positionID = positions.get(i).getPositionId();
                                int index = mSelectedPositions.indexOf(positionID);

                                Log.d(LOG_TAG, "onClick: " + positionID);

                                if (index >= 0)
                                    mSelectedPositions.remove(index);
                            }
                        }
                        if (checked) {
                            if (stringBuilder.length() > 0)
                                stringBuilder.append(", ");
                            stringBuilder.append(list.getItemAtPosition(i));
                        }
                    }
                    /*Check string builder is empty or not. If string builder is not empty.
                      It will display on the screen.
                     */
                    if (!stringBuilder.toString().trim().equals("")) {
                        searchingAs.setText(stringBuilder);
                    } else {
                        searchingAs.setText("");
                    }

                }
            }).setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    //
                }
            }).show();
        } else {
            DialogUtility.showDialogWithOneButton(this, Constants.APP_NAME, "Cannot load positions.Please check your internet connection");
        }
    }


    public void registerUser() {

        if (name.getText().toString().length() == 0 || email.getText().toString().length() == 0 ||
                password.getText().toString().length() == 0 || rePassword.getText().toString().length() == 0) {
            // || searchingAs.getText().toString().length() ==0){
            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.REQUIRED_FIELDS);
        } else if (mSelectedPositions.size() == 0) {
            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Please choose position");
        } else if (!Utility.isValidEmail(email.getText().toString().trim())) {
            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.INVALID_EMAIL);
        } else if (password.getText().toString().length() < 8) {
            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.INVALID_PASSWORD_LENGTH);
        } else if (!password.getText().toString().equals(rePassword.getText().toString())) {
            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, Constants.PASSWORD_VERIFY);
        } else if (!tAndC_cb.isChecked()) {
            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Please accept the terms and conditions to proceed");
        } else {

            String authHeader = PreferencesData.getString(RegisterActivity.this, Constants.AUTHORIZATION_KEY, "");
            JsonObject registerUserJsonObject = new JsonObject();
            registerUserJsonObject.addProperty("name", name.getText().toString());
            registerUserJsonObject.addProperty("username", email.getText().toString());
            registerUserJsonObject.addProperty("password", password.getText().toString());

            JsonArray mPositionsArray = new JsonArray();
            for (int item : mSelectedPositions) {
                mPositionsArray.add(new JsonPrimitive(item + ""));
            }
            registerUserJsonObject.add("position", mPositionsArray);

            if (Utility.isConnectingToInternet(context)) {
                Utility.showProgressDialog(context);
                RetroHelper.getBaseClassService(context, "", "").registerUser(registerUserJsonObject, new Callback<JsonObject>() {
                    @Override
                    public void success(JsonObject jsonObject, Response response) {
                        Utility.dismissDialog();
                        if (jsonObject != null && jsonObject.toString().length() > 0) {
                            Log.d("SUCCESS sendcode", jsonObject.toString());
                            //      Toast.makeText(context, jsonObject.get("success").toString(), Toast.LENGTH_LONG).show();
                            Intent i = new Intent(context, VerifyEmailActivity.class);
                            i.putExtra(Constants.SUCCESS_MESSAGE, jsonObject.get("success").toString());
                            startActivity(i);
                            finish();
                        }
                    }

                    @Override
                    public void failure(RetrofitError retrofitError) {
                        Utility.dismissDialog();
                        Utility.serviceCallFailureMessage(retrofitError, activity);
                    }
                });
            } else {
                //Toast.makeText(context, "Please check internet connection", Toast.LENGTH_LONG).show();
                DialogUtility.showDialogWithOneButton(activity, Constants.NO_NETWORK_HEADER, Constants.NO_NETWORK);
            }

        }
    }

    void getPositionsFromServer() {
        RetroHelper.getBaseClassService(context, "", "").getDropDownListData(new Callback<JsonObject>() {
            JsonArray positionsArray;

            @Override
            public void success(JsonObject jsonObject, Response response) {
                Log.d(LOG_TAG, "success: ");

                if (jsonObject != null && jsonObject.has("positions")) {
                    positionsArray = jsonObject.getAsJsonArray("positions");
                    Type type = new TypeToken<List<Position>>() {
                    }.getType();
                    positions = new Gson().fromJson(positionsArray.toString(), type);
                    if (positions != null) {
                        mSelectedPositionArray = new boolean[positions.size()];
                    }
                }
            }

            @Override
            public void failure(RetrofitError error) {
                Utility.serviceCallFailureMessage(error, activity);

            }
        });
    }

    /*@OnClick(R.id.show_terms_and_conditions)
    void onTermsAndConditionsClick() {
        DialogUtility.showTermsAndConditionsDialog(this,false);
    }*/

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }

  /*  public void getDropDownListData(){
        String authHeader = PreferencesData.getString(RegisterActivity.this, Constants.AUTHORIZATION_KEY, "");
     //   JsonObject registerUserJsonObject = new JsonObject();
        if(Utility.isConnectingToInternet(context)){
            Utility.showProgressDialog(context);
            RetroHelper.getBaseClassService("",authHeader).getDropDownListData(new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();
                    Log.d("Response", jsonObject.toString());
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                }
            });
        }
    }
*/
}
