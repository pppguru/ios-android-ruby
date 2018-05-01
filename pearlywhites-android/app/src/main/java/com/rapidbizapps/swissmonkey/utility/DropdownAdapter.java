package com.rapidbizapps.swissmonkey.utility;

import android.content.Context;
import android.graphics.Typeface;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.rapidbizapps.swissmonkey.models.Position;

import java.util.List;

/**
 * Created by mlanka on 30-08-2016.
 */
public class DropdownAdapter<T> extends ArrayAdapter<T> {

    Typeface font;

    public DropdownAdapter(Context context, int resource, List objects) {
        super(context, resource, objects);
        font = Typeface.createFromAsset(context.getAssets(), "fonts/Lato-Light.ttf");
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        TextView view = (TextView) super.getView(position, convertView, parent);
        view.setTypeface(font);
        return view;



    }
}
