package com.moodysalem.pgpmessager.model;

import com.moodysalem.pgpmessager.hibernate.Entry;

public class LinkEmailModel {
    private Entry entry;
    private String requestUrl;

    public String getRequestUrl() {
        return requestUrl;
    }

    public void setRequestUrl(String requestUrl) {
        this.requestUrl = requestUrl;
    }

    public Entry getEntry() {
        return entry;
    }

    public void setEntry(Entry entry) {
        this.entry = entry;
    }
}
