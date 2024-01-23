package com.kakaocloud.library.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormatter  {

    private static final String pattern = "yyyyMMdd";
    private static final SimpleDateFormat formatter = new SimpleDateFormat(pattern);

    public static String getDateToString(Date date) {
        return formatter.format(date);
    }
}

