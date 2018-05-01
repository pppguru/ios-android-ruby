package com.rapidbizapps.swissmonkey.utility;

import android.text.InputFilter;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.util.Log;

/**
 * Created by mlanka on 24-08-2016.
 */
public class FirstLetterCapFilter implements InputFilter {
    private static final String LOG_TAG = "FirstLetterCapFilter";

    @Override
    public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
        if (source != null && source.length() != 0) {
            char initial = source.charAt(start);
            Log.d(LOG_TAG, "filter: dstart " + dstart);
            Log.d(LOG_TAG, "filter: dend " + dend);
            Log.d(LOG_TAG, "filter: start " + start);
            Log.d(LOG_TAG, "filter: end " + end);
            if (dstart == 0 && Character.isLowerCase(initial)) {
                String temp = source.toString().replace(initial, Character.toUpperCase(initial));
                Log.d(LOG_TAG, "filter: temp " + temp);
                if (source instanceof Spanned) {
                    SpannableString sp = new SpannableString(temp);
                    TextUtils.copySpansFrom((Spanned) source, start, end, null, sp, 0);
                    Log.d(LOG_TAG, "filter: " + sp);
                    return sp;
                } else {
                    return temp;
                }
            }
        }

        return null; // keep original
    }
}

